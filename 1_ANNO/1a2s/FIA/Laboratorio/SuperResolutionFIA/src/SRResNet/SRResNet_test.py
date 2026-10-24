import torch
from torch.utils.data import DataLoader
from skimage.metrics import peak_signal_noise_ratio
from SRResNet_dataset import DIV2KDataset
from SRResNet_model import SRResNet

device = torch.device("cuda" if torch.cuda.is_available() else "cpu")

scaling_factor = 4      # eval non funziona con X8
hr_dir = "./DIV2K/DIV2K_valid_HR"
lr_dir = "./DIV2K/DIV2K_valid_LR_bicubic_X{scale:}/X{scale:}".format(scale=scaling_factor)
load_checkpoint = "./SRResNet_50epochs_X4_MSE_0.004.pth"

model = SRResNet(scaling_factor=scaling_factor).to(device)
model.load_state_dict(torch.load(load_checkpoint, map_location=device, weights_only=True))
model.eval()

test_dataset = DIV2KDataset(hr_dir=hr_dir, lr_dir=lr_dir, split="test", crop_size=0, scaling_factor=scaling_factor)
test_loader = DataLoader(test_dataset, batch_size=1, shuffle=True)

PSNRs = []

with torch.no_grad():
    for i, (hr_img, lr_img) in enumerate(test_loader):
        hr_img = hr_img.to(device)
        lr_img = lr_img.to(device)
        sr_img = model(lr_img)

        psnr = peak_signal_noise_ratio(hr_img.cpu().numpy(), sr_img.cpu().numpy())
        PSNRs.append(psnr)
        print("Batch[{0}/{1}]".format(i+1, len(test_loader)))

print("PSNR - {psnr:.2f}".format(psnr=sum(PSNRs)/len(PSNRs)))