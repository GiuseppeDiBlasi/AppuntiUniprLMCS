import torch
import random
from PIL import Image
import torchvision.transforms as transforms
import torchvision.transforms.functional as TF
from SRResNet_model import SRResNet

device = torch.device("cuda" if torch.cuda.is_available() else "cpu")

scaling_factor = 2      # Dipende dalla cartella di LR che si usa: se è X2, allora scaling_factor=2;
                        # se è X4, allora scaling_factor=4;
loss = "L1"             # MSE o L1
load_checkpoint = "./SRResNet_50epochs_X2_L1_0.020.pth"
# load_checkpoint = "./SRResNet_50epochs_X2_MSE_0.002.pth"
# load_checkpoint = "./SRResNet_50epochs_X4_L1_0.034.pth"
# load_checkpoint = "./SRResNet_50epochs_X4_MSE_0.004.pth"

model = SRResNet(scaling_factor=scaling_factor).to(device)
model.load_state_dict(torch.load(load_checkpoint, map_location=device, weights_only=True))
model.eval()

rand = 91 # random.randint(1, 99)

def generate(lr_img):
    lr_img = Image.open(lr_img, mode="r")
    lr_img = TF.to_tensor(lr_img).to(device)

    with torch.no_grad():
        sr_img = model(lr_img)

    sr_img.clamp_(0, 1)             # Rimuove artefatti
    sr_img = TF.to_pil_image(sr_img)
    sr_img.save("./SR/SR08{rand:02d}x{scale:}_{loss:}.png".format(rand=rand, scale=scaling_factor, loss=loss))

if __name__ == '__main__':
    print("./DIV2K/DIV2K_valid_LR_bicubic_X{scale:}/X{scale:}/08{rand:02d}x{scale:}.png".format(rand=rand, scale=scaling_factor))
    generate("./DIV2K/DIV2K_valid_LR_bicubic_X{scale:}/X{scale:}/08{rand:02d}x{scale:}.png".format(rand=rand, scale=scaling_factor))