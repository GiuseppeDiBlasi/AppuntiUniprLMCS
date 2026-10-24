import os

import time
from matplotlib import pyplot as plt
from torch.utils.data import DataLoader
import torch
import torchvision.transforms.functional as TF

from config import *
from dataset import DIV2KDataset
from srcnn import SRCNN

from config import *

from PIL import Image

from pathlib import Path

from datetime import datetime

import glob

from utils import *


# carica modelli a 3 layer
#model_dirs = sorted(glob.glob(os.path.join(MODELS_DIR, "*LY:128-128-64*/")))
#model_dirs = sorted(glob.glob(os.path.join(MODELS_DIR, "*LY:64-64-64-64-64-64-64*/")))
#model_dirs = sorted(glob.glob(os.path.join(MODELS_DIR, "*LY:64-64-64-64-64-64-64*/")))
model_dirs = sorted(glob.glob(os.path.join(MODELS_DIR, "*LY:64-64-64-64-64-64-64-64-64-64-64-64-64-64-64-64-64-64-64-64*/")))

#carica modelli a 2 layer
#model_dirs = sorted(glob.glob(os.path.join(MODELS_DIR, "*/")))

latest_model_dir = model_dirs[-1]  # e.g. ../../models/srcnn(LY:128-128-64)_.../

MODEL_NAME = os.path.basename(latest_model_dir.rstrip("/"))
MODEL_DIR  = latest_model_dir
MODEL_PNGS = os.path.join(MODEL_DIR, "pngs/")
MODEL      = glob.glob(os.path.join(MODEL_DIR, "*.pth"))[0]

os.makedirs(MODEL_PNGS, exist_ok=True)
print(f"Modello caricato: {MODEL_NAME}")

device = torch.device('cuda' if torch.cuda.is_available() else 'cpu')

print("LOADING DATASET")

dataset_test = DIV2KDataset(TEST_DATASET_SET5, TEST_DATASET_SET5, DATASET_TEST_STR)

test_loader = DataLoader(
    dataset_test,
    batch_size=1,
    shuffle=False
)

#print(f"Numero immagini nel test set: {len(dataset_test)}")
#print(f"Numero batch nel test loader: {len(test_loader)}")
#print(list(Path(TEST_DATASET_SET5).glob("*")))
#print(Path(TEST_DATASET_SET5).resolve())

print("DATASET LOADED")

model = SRCNN().to(device)

# Carica stato della rete
model.load_state_dict(torch.load(MODEL, map_location=device))

#for name, param in model.named_parameters():
    #print(name, param.data.mean().item())
    #break  # stampa solo il primo layer


 # Inferenza modello
best_psnr = 0

total_imgs = len(test_loader)

# Contatore per tenere conto di quando la rete supera LR
count_sr_better = 0

psnr_sr_history = []
psnr_bicubic_history = []

start = time.time()
avg_time_per_image = 0

print("STARTING TEST")
# 1. Carica l'immagine LR
for i, (lr_batch, hr_batch) in enumerate(test_loader):
    #lr_batch, hr_batch = next(iter(test_loader))
    image_start = time.time()
    lr_batch = lr_batch.to(device)
    hr_batch = hr_batch.to(device)

    lr_y = lr_batch[:, 0:1, :, :]  # shape [batchSize, 1, H, W]
    hr_y = hr_batch[:, 0:1, :, :]  # shape [batchSize, 1, H, W]

    lr_y = lr_y.to(device)
    hr_y = hr_y.to(device)

    model.eval()

    with torch.no_grad():
        output = model(lr_y)


    # estrai Cb e Cr dal batch originale
    cb = TF.to_pil_image(lr_batch.squeeze(0)[1].clamp(0, 1))
    cr = TF.to_pil_image(lr_batch.squeeze(0)[2].clamp(0, 1))

    # ricostruisci le tre immagini a colori
    y_lr_pil  = TF.to_pil_image(lr_y.squeeze(0).clamp(0, 1))
    y_sr_pil  = TF.to_pil_image(output.squeeze(0).clamp(0, 1))
    y_hr_pil  = TF.to_pil_image(hr_y.squeeze(0).clamp(0, 1))

    lr_img = Image.merge('YCbCr', [y_lr_pil, cb, cr]).convert('RGB')
    sr_img = Image.merge('YCbCr', [y_sr_pil, cb, cr]).convert('RGB')
    hr_img = Image.merge('YCbCr', [y_hr_pil, cb, cr]).convert('RGB')

    psnr_bicubic = psnr(lr_y, hr_y)
    psnr_sr = psnr(output, hr_y)

    psnr_bicubic_history.append(psnr_bicubic)
    psnr_sr_history.append(psnr_sr)

    if psnr_sr > psnr_bicubic:
        count_sr_better += 1

        fig, axes = plt.subplots(1, 3, figsize=(18, 6))

        axes[0].imshow(lr_img)
        axes[0].set_title('LR Bicubic')
        axes[0].axis('off')

        axes[1].imshow(sr_img)
        axes[1].set_title('SR (rete)')
        axes[1].axis('off')

        axes[2].imshow(hr_img)
        axes[2].set_title('HR Originale')
        axes[2].axis('off')

        PNG_NAME = "confronto_" + MODEL_NAME

        fig.text(0.5, 0.02,
                f'PSNR Bicubic: {psnr_bicubic:.2f} dB  |  PSNR SR: {psnr_sr:.2f} dB',
                ha='center', fontsize=12,
                bbox=dict(boxstyle='round', facecolor='white', alpha=0.8))

        plt.tight_layout()
        plt.savefig(os.path.join(MODEL_PNGS, PNG_NAME), bbox_inches='tight', dpi=150)
        # plt.show()

        lr_img.save(os.path.join(MODEL_PNGS, f"lr_{PNG_NAME}.png"))
        sr_img.save(os.path.join(MODEL_PNGS, f"sr_{PNG_NAME}.png"))
        hr_img.save(os.path.join(MODEL_PNGS, f"hr_{PNG_NAME}.png"))

    image_time = time.time() - image_start
    avg_time_per_image = (avg_time_per_image * i + image_time) / (i + 1)
    elapsed = time.time() - start
    remaining = avg_time_per_image * (total_imgs - (i + 1))

    elapsed_str   = time.strftime("%H:%M:%S", time.gmtime(elapsed))
    remaining_str = time.strftime("%H:%M:%S", time.gmtime(remaining))

    log_line = f"Img:{i+1}/{total_imgs}; PSNR_BIC:{psnr_bicubic:.2f}; PSNR_SR:{psnr_sr:.2f}; SR_BETTER_COUNT:{count_sr_better}/{total_imgs}, ETA:{remaining_str}"

    print(log_line)

    # Salvo il miglior risultato ottenuto
    # if best_psnr < psnr_sr:
        # best_psnr = psnr_sr


    with open(os.path.join(MODEL_PNGS, "test_log.txt"), 'a') as f:
        f.write(log_line + '\n')

    # Libero la VRAM
    del lr_batch, hr_batch, lr_y, hr_y, output
    torch.cuda.empty_cache()

print("TEST TERMINATED")