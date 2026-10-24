
# # Progetto Super Resolution
#
# L'obiettivo del progetto è addestrare una rete che prende in input immagini a bassa risoluzione e ne migliora la qualità
#
# Verrà usato il dataset DIV2K; Da ogni immagine ad alta risoluzione (HR) verrà estratta una patch per addestrare la rete.
#
# In fase di training le immagini vengono ritagliate in n patch casuali, nella fase di validazione si usano le immagini intere

import time
import torch

import torch.nn as nn
import torch.optim as optim

import matplotlib.pyplot as plt

from torchvision import transforms
import os
import random
from torch.utils.data import DataLoader
from pathlib import Path
from PIL import Image

from config import *

from dataset import DIV2KDataset

from srcnn import SRCNN

from utils import *

# SEED FISSO
if FIXED_SEED:
    print("seed fissato")
    set_seed(42)

# Device configuration
device = torch.device('cuda' if torch.cuda.is_available() else 'cpu')

print(device)


print(torch.cuda.is_available())
print(torch.version.hip)
print(torch.version.cuda)

# Caricamento dei dataset

# Carico il dataset di training


print("LOADING DATASET")



dataset_train = DIV2KDataset(DIV2K_TRAIN_HR_DIR, DIV2K_TRAIN_LR_BICUB_2X)

train_loader = DataLoader(
    dataset_train,
    batch_size=16,
    shuffle=True
)

dataset_valid = DIV2KDataset(DIV2K_VALID_HR_DIR, DIV2K_VALID_LR_BICUB_2X, DATASET_VALIDATION_STR)

valid_loader = DataLoader(
    dataset_valid,
    batch_size=1,
    shuffle=False
)

print("DATASET LOADED")

# # Loop di addestramento
# La loss function deve calcolare la differenza tra l'immagine da manipolare con l'immagine di destinazione
#
# ### Loss function MSE
# Calcola lo scarto quadratico medio tra i 2 pixel
#
# ### L1 Loss function
# Calcola il valore assoluto dell'errore

model = SRCNN().to(device)

criterion = None

#nn.L1Loss()
if L1_LOSS:
    criterion = nn.L1Loss()
else:
    criterion = nn.MSELoss()

optimizer = optim.Adam(model.parameters(), lr=LEARNING_RATE)
# optimizer = torch.optim.Adam([
#     {'params': model.conv1.parameters(), 'lr': 1e-4},
#     {'params': model.conv2.parameters(), 'lr': 1e-4},
#     {'params': model.conv3.parameters(), 'lr': 1e-4},
#     {'params': model.convEnd.parameters(), 'lr': 1e-5},
# ])

MILESTONE = 320

# Scheduler 1: learning rate costante per epoche fino a MILESTONE
#scheduler1 = torch.optim.lr_scheduler.ConstantLR(optimizer, factor=1.0, total_iters=MILESTONE)

# Scheduler 2: dimezza ogni 50 epoche dopo la MILESTONE
#scheduler2 = torch.optim.lr_scheduler.StepLR(optimizer, step_size=50, gamma=0.65)

# Concateno i due scheduler
#scheduler = torch.optim.lr_scheduler.SequentialLR(
#    optimizer,
#    schedulers=[scheduler1, scheduler2],
#    milestones=[MILESTONE]
#)

scheduler = torch.optim.lr_scheduler.StepLR(optimizer, step_size=80, gamma=0.65)

from datetime import datetime

best_loss = float('inf')

timestamp = datetime.now().strftime("%Y-%m-%d_%H-%M-%S")

model_architecture = model.print_architecture()

RUN_NAME = f"srcnn{model_architecture}_model_{EPOCHS}_epochs_{timestamp}"
MODEL_DATA_PATH = f"{MODELS_DIR}/{RUN_NAME}"

os.makedirs(MODEL_DATA_PATH, exist_ok=True)

SAVE_PATH = f"{MODEL_DATA_PATH}/srcnn_{EPOCHS}_epochs_{timestamp}.pth"
LOG_PATH  = f"{MODEL_DATA_PATH}/LOG_srcnn_{EPOCHS}_epochs_{timestamp}.txt"

print("TRAINING STARTED")

# tempo inizio training
start_time = time.time()

loss_history = []
psnr_history = []
best_psnr = 0

epoch_with_no_imprv = 0

# Media per terminare un epoca
avg_time_per_epoch = 0


print("\n\n")
print(print_config(model, optimizer))


with open(LOG_PATH, 'a') as f:
        f.write(print_config(model, optimizer) + '\n')
        f.write(model.print_architecture() + '\n')

for epoch in range(EPOCHS):
    if epoch_with_no_imprv == EPOCHS_WITHOUT_IMPROVEMENT and EARLY_STOPPING:
        log_line = f"STOPPED AT EPOCH:{epoch}; NO IMPROVEMENT AFTER {EPOCHS_WITHOUT_IMPROVEMENT} EPOCHS...TRAINING STOPPED"
        print(log_line)

        with open(LOG_PATH, 'a') as f:
            f.write(log_line + '\n')

        break

    running_loss = 0.0
    epoch_start = time.time()

    for lr_batch, hr_batch in train_loader:
        lr_batch = lr_batch.to(device)
        hr_batch = hr_batch.to(device)

        lr_y = lr_batch[:, 0:1, :, :]  # shape [batchSize, 1, H, W]
        hr_y = hr_batch[:, 0:1, :, :]  # shape [batchSize, 1, H, W]

        lr_y = lr_y.to(device)
        hr_y = hr_y.to(device)

        optimizer.zero_grad()

        output = model(lr_y)

        loss = criterion(output, hr_y)

        loss.backward()
        optimizer.step()

        running_loss += loss.item()

    # Calcolo dati log
    # Calcolo loss
    avg_loss = running_loss / len(train_loader)

    # Tempo impiegato per un epoca
    epoch_time = time.time() - epoch_start
    avg_time_per_epoch = (avg_time_per_epoch * epoch + epoch_time) / (epoch + 1)

    # Step dello scheduler
    scheduler.step()

    # Aggiungo i learning rate di ogni layer
    #lrs = [group['lr'] for group in optimizer.param_groups]
    #lr_str = f"L1={lrs[0]:.8f} L2={lrs[1]:.8f} L3={lrs[2]:.8f}"

    lr_str = f"LR:{optimizer.param_groups[0]['lr']}"

    if VALIDATION_PHASE:
        # Fase di validation
        avg_psnr = validation_patch_overlap(device, valid_loader, model)
        psnr_history.append(avg_psnr)
        model.train()



    # Calcolo tempo rimanente alla fine dell'addestramento
    remaining_time = avg_time_per_epoch * (EPOCHS - (epoch + 1))
    remaining_time_str = time.strftime("%H:%M:%S", time.gmtime(remaining_time))

    elapsed = time.time() - start_time
    elapsed_str = time.strftime("%H:%M:%S", time.gmtime(elapsed))

    #log_line = f"Epoch {epoch+1}/{EPOCHS}, Loss: {avg_loss:.10f}, LR: {scheduler.get_last_lr()[0]:.8f}"
    log_line = f"Epoch:{epoch+1}/{EPOCHS}, Loss:{avg_loss:.10f}, Elapsed Time:{elapsed_str}, ETA:{remaining_time_str}, LR: {lr_str}"

    if VALIDATION_PHASE:

        log_line += f", avg.PSNR:{avg_psnr:.2f}"
        # Salvo il modello solo se è migliorato l'indicatore PSNR
        if avg_psnr > best_psnr:
            epoch_with_no_imprv = 0
            best_psnr = avg_psnr
            log_line += ", MODEL SAVED"
            torch.save(model.state_dict(), SAVE_PATH)

    # Salvo il modello al miglioramento della loss se non ho validation
    else:
        if avg_loss < best_loss and not VALIDATION_PHASE:
            best_loss = avg_loss
            log_line += ", MODEL SAVED"
            torch.save(model.state_dict(), SAVE_PATH)


    print(log_line)

    with open(LOG_PATH, 'a') as f:
        f.write(log_line + '\n')

    loss_history.append(avg_loss)

    epoch_with_no_imprv += 1

    # Salva il grafico ad ogni epoca
    plt.figure(figsize=(10, 5))
    plt.plot(range(1, len(loss_history)+1), loss_history, label='Training Loss')
    plt.xlabel('Epoca')
    plt.ylabel('Loss')
    plt.title('Training Loss')
    plt.legend()
    plt.grid(True)
    plot_path = SAVE_PATH.replace('.pth', '_loss_plot.png')
    plt.savefig(plot_path, bbox_inches='tight', dpi=150)
    plt.close()



    if VALIDATION_PHASE:
        # Salva il grafico, PSNR, ad ogni epoca
        plt.figure(figsize=(10, 5))
        plt.plot(range(1, len(psnr_history)+1), psnr_history, label='PSNR')
        plt.xlabel('Epoca')
        plt.ylabel('PSNR')
        plt.title('Indice PSNR')
        plt.legend()
        plt.grid(True)
        plot_path = SAVE_PATH.replace('.pth', '_psnr_plot.png')
        plt.savefig(plot_path, bbox_inches='tight', dpi=150)
        plt.close()




print("TRAINING ENDED")
