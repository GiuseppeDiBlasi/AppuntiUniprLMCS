import time
import torch
import datetime
from torch import nn
from torch.utils.data import DataLoader
from SRResNet_dataset import DIV2KDataset
from SRResNet_model import SRResNet

scaling_factor = 4      # Dipende dalla cartella di LR che si usa: se è X2, allora scaling_factor=2;
                        # se è X4, allora scaling_factor=4;
loss = "L1"             # MSE o L1
epochs = 50
lr = 0.0001
batch_size = 16
crop_size = 92
best_loss = 99

hr_dir = "./DIV2K/DIV2K_train_HR"
lr_dir = "./DIV2K/DIV2K_train_LR_bicubic_X{scale:}/X{scale:}".format(scale=scaling_factor)
hr_dir_v = "./DIV2K/DIV2K_valid_HR"
lr_dir_v = "./DIV2K/DIV2K_valid_LR_bicubic_X{scale:}/X{scale:}".format(scale=scaling_factor)
save_checkpoint = "./SRResNet_{epochs:}epochs_X{scale:}_{loss:}".format(epochs=epochs, scale=scaling_factor, loss=loss)

device = torch.device("cuda" if torch.cuda.is_available() else "cpu")

def main():
    model = SRResNet(scaling_factor=scaling_factor).to(device)
    optimizer = torch.optim.Adam(model.parameters(), lr=lr)
    train_dataset = DIV2KDataset(hr_dir=hr_dir, lr_dir=lr_dir, split="train", crop_size=crop_size, scaling_factor=scaling_factor)
    train_loader = DataLoader(train_dataset, batch_size=16, shuffle=True)
    valid_dataset = DIV2KDataset(hr_dir=hr_dir_v, lr_dir=lr_dir_v, split="train", crop_size=crop_size, scaling_factor=scaling_factor)
    valid_loader = DataLoader(valid_dataset, batch_size=16, shuffle=True)

    if loss == "MSE":
        criterion = nn.MSELoss().to(device)
    elif loss == "L1":
        criterion = nn.L1Loss().to(device)

    start = time.time()
    for epoch in range(epochs):
        train(train_loader=train_loader,
              valid_loader=valid_loader,
              model=model,
              criterion=criterion,
              optimizer=optimizer,
              epoch=epoch)

    total_time = time.time() - start
    print("Total time: "+str(datetime.timedelta(seconds = int(total_time))))

def train(train_loader, valid_loader, model, criterion, optimizer, epoch):
    global best_loss
    train_losses = []
    valid_losses = []
    start = time.time()
    
    model.train()
    for _, (hr_imgs, lr_imgs) in enumerate(train_loader):
        hr_imgs = hr_imgs.to(device)
        lr_imgs = lr_imgs.to(device)
        sr_imgs = model(lr_imgs)

        loss = criterion(sr_imgs, hr_imgs)
        train_losses.append(loss)
        optimizer.zero_grad()
        loss.backward()
        optimizer.step()

    model.eval()
    for _, (hr_imgs, lr_imgs) in enumerate(valid_loader):
        hr_imgs = hr_imgs.to(device)
        lr_imgs = lr_imgs.to(device)
        sr_imgs = model(lr_imgs)

        loss = criterion(sr_imgs, hr_imgs)
        valid_losses.append(loss)

    epoch_time = time.time() - start
    if best_loss > sum(valid_losses)/len(valid_losses):
        best_loss = sum(valid_losses)/len(valid_losses)
        torch.save(model.state_dict(), save_checkpoint + "_{loss:.3f}".format(loss=best_loss) + ".pth")
    
    print("Epoch[{0}] Average Training Loss: {train_loss:.3f} - Average Validation Loss: {valid_loss:.3f} - Epoch time: {time:.1f}s".format(epoch+1,
                                                                                                                train_loss=sum(train_losses)/len(train_losses),
                                                                                                                valid_loss=sum(valid_losses)/len(valid_losses),
                                                                                                                time=epoch_time))

if __name__ == "__main__":
    main()