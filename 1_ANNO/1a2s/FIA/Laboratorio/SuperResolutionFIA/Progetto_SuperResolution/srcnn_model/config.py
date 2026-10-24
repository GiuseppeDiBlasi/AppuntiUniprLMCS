import torch
import random
import numpy as np

def set_seed(seed=42):
    random.seed(seed)
    np.random.seed(seed)
    torch.manual_seed(seed)
    torch.cuda.manual_seed(seed)
    torch.cuda.manual_seed_all(seed)

DIV2K_TRAIN_HR_DIR = "../../dataset/DIV2K_train_HR"
DIV2K_VALID_HR_DIR = "../../dataset/DIV2K_valid_HR"

DIV2K_TRAIN_LR_BICUB_2X = "../../dataset/DIV2K_train_LR_bicubic/X2"
DIV2K_VALID_LR_BICUB_2X = "../../dataset/DIV2K_valid_LR_bicubic/X2"

TEST_DATASET_SET5 = "../../dataset/test_dataset/set5/Set5"
TEST_DATASET_SET14 = "../../dataset/test_dataset/set14/Set14"

DATASET_TRAIN_STR: str = "train"
DATASET_VALIDATION_STR: str = "validation"
DATASET_TEST_STR: str = "test"

DW_SCALE: int = 2

LEARNING_RATE = 1e-4
EPOCHS = 600

MODELS_DIR = "../../models"

FIXED_SEED = True

# Per fare residual learning, guardare implementazione modello
RESIDUAL = True

# Quando la validazione è true, salvo al migliorare del PSNR e non della loss
VALIDATION_PHASE = True

# Se usare la validation con patch overlap invece di prenrdere una patch centrale dalla foto
VALIDATION_PATCH_OVERLAP = True

EARLY_STOPPING = True
EPOCHS_WITHOUT_IMPROVEMENT = 120

PATCH_PER_IMAGE = 40
PATCH_SIZE = 128

L1_LOSS = True

# Ogni quante epoche fare validation durante il training
# Per ora non è implementato
VALIDATION_STEP = 10

BATCH_NORMALIZATION = True

CHANNELS = [64] * 20
KERNELS = [9] + [5] * 19

def print_config(model, optimizer):
    lrs = [group['lr'] for group in optimizer.param_groups]

    if len(lrs) == 1:
        lr_str = f"LR={lrs[0]:.10f}"
    else:
        lr_str = f"L1={lrs[0]:.10f} L2={lrs[1]:.10f} L3={lrs[2]:.10f}"

    return f"""
EPOCHS = {EPOCHS}
L1 LOSS = {L1_LOSS}
BATCH NORMALIZATION = {BATCH_NORMALIZATION}
FIXED SEED = {FIXED_SEED}
RESIDUAL LEARNING = {RESIDUAL}
PATCH PER IMAGE = {PATCH_PER_IMAGE}
PATCH SIZE = {PATCH_SIZE}
EARLY STOPPING = {EARLY_STOPPING}
EPOCHS WITHOUT IMPROVMENT = {EPOCHS_WITHOUT_IMPROVEMENT}
VALIDATION PHASE = {VALIDATION_PHASE}
VALIDATION STEP = {VALIDATION_STEP}
VALIDATION PATCH OVERLAP = {VALIDATION_PATCH_OVERLAP}
MODEL ARCHITECTURE = {model.print_architecture()}
LEARNING RATES = {lrs}
"""