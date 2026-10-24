import os

from matplotlib import pyplot as plt
from torch.utils.data import DataLoader
import torch
import torchvision.transforms.functional as TF

from config import *
from dataset import DIV2KDataset
from srcnn import SRCNN

from config import *


from pathlib import Path

def psnr(output, target, max_val=1.0):
    mse = torch.mean((output - target) ** 2)
    if mse == 0:
        return float('inf')
    return 10 * torch.log10(torch.tensor(max_val ** 2) / mse).item()

def inference_full_image(model, lr_tensor, patch_size=128, stride=128, device='cuda'):
    """
    Esegue l'inferenza sull'immagine intera dividendola in patch.

    patch_size: dimensione della patch (es. 128x128)
    stride: di quanto si sposta la finestra ad ogni passo.
            stride == patch_size → nessun overlap, patch adiacenti (più veloce, ok per validation)
            stride < patch_size  → overlap tra patch, si fa la media nelle zone sovrapposte
                                   (più lento, qualità migliore, utile per il test finale)
    """
    _, _, H, W = lr_tensor.shape

    # Padding per coprire i bordi non divisibili per patch_size
    pad_h = (patch_size - H % patch_size) % patch_size
    pad_w = (patch_size - W % patch_size) % patch_size

    if pad_h > 0 or pad_w > 0:
        lr_tensor = torch.nn.functional.pad(lr_tensor, (0, pad_w, 0, pad_h), mode='reflect')

    _, _, H_pad, W_pad = lr_tensor.shape
    output = torch.zeros_like(lr_tensor)
    count  = torch.zeros_like(lr_tensor)

    for y in range(0, H_pad - patch_size + 1, stride):
        for x in range(0, W_pad - patch_size + 1, stride):
            patch = lr_tensor[:, :, y:y+patch_size, x:x+patch_size]
            with torch.no_grad():
                pred = model(patch)
            output[:, :, y:y+patch_size, x:x+patch_size] += pred
            count[:, :,  y:y+patch_size, x:x+patch_size] += 1
            del patch, pred
            torch.cuda.empty_cache()

    count = count.clamp(min=1)
    result = output / count

    # Rimuovi il padding aggiunto
    return result[:, :, :H, :W]


def validation_patch_overlap(device, valid_loader: DataLoader, model: SRCNN):
    psnr_sum = 0

    for i, (lr_batch, hr_batch) in enumerate(valid_loader):
        lr_batch = lr_batch.to(device)
        hr_batch = hr_batch.to(device)

        lr_y = lr_batch[:, 0:1, :, :]
        hr_y = hr_batch[:, 0:1, :, :]

        del lr_batch, hr_batch
        torch.cuda.empty_cache()

        model.eval()

        output = inference_full_image(model, lr_y, patch_size=PATCH_SIZE, stride=PATCH_SIZE, device=device)

        psnr_sr = psnr(output, hr_y)

        del output, lr_y, hr_y
        torch.cuda.empty_cache()

        psnr_sum += psnr_sr

    avg_psnr = psnr_sum / len(valid_loader)
    return avg_psnr

def validation(device, valid_loader: DataLoader, model: SRCNN):
    avg_psnr = 0
    psnr_sum = 0

    for i, (lr_batch, hr_batch) in enumerate(valid_loader):
        #print(f"Image {i+1}: lr={lr_batch.shape}, hr={hr_batch.shape}")

        lr_batch = lr_batch.to(device)
        hr_batch = hr_batch.to(device)

        _, _, h, w = hr_batch.shape

        center_h = h // 2
        center_w = w // 2
        half = PATCH_SIZE // 2

        # Il pre-upsampling per LR è fatto dentro al get
        lr_y = lr_batch[:, 0:1, center_h-half:center_h+half, center_w-half:center_w+half]
        hr_y = hr_batch[:, 0:1, center_h-half:center_h+half, center_w-half:center_w+half]

        lr_y = lr_y.to(device)
        hr_y = hr_y.to(device)

        model.eval()

        with torch.no_grad():
            output = model(lr_y)

        psnr_bicubic = psnr(lr_y, hr_y)
        psnr_sr = psnr(output, hr_y)

        # Libera la VRAM dopo ogni immagine
        del lr_batch, hr_batch, lr_y, hr_y, output
        torch.cuda.empty_cache()

        psnr_sum += psnr_sr

    avg_psnr = psnr_sum / len(valid_loader)
    return avg_psnr




