from pathlib import Path
import random

from torch.utils.data import Dataset

from torchvision import transforms

from config import *

from PIL import Image

class DIV2KDataset(Dataset):
    # hr_dir e lr_dir sono le directory per i due dataset
    # scale, è il downscaling factor
    # patch_per_img, quante patch per ogni immagine
    # patch_size, quanto è grande una patch che verrà estratta
    
    def __init__(self, hr_dir, lr_dir, mode=DATASET_TRAIN_STR, scale=DW_SCALE, patches_per_img=20, patch_size=64):
        super().__init__()

        self.scale = scale
        self.patches_per_img = patches_per_img
        self.patch_size = patch_size
        self.mode = mode

        # Carico i path per ogni immagine HR e LR
        self.hr_paths = sorted(Path(hr_dir).glob("*.png"))
        self.lr_paths = sorted(Path(lr_dir).glob("*.png"))

        self.lr_patches = []
        self.hr_patches = []
        
        # Oggetto per convertire dati in tensori
        self.to_tensor = transforms.ToTensor()

        if self.mode == DATASET_TRAIN_STR:
            self._build_patches()
        elif self.mode == DATASET_TEST_STR:
            self.hr_imgs = [Image.open(p).convert('YCbCr') for p in self.lr_paths]
        else:
            self.lr_imgs = [Image.open(p).convert('YCbCr') for p in self.lr_paths]
            self.hr_imgs = [Image.open(p).convert('YCbCr') for p in self.hr_paths]

    # Restituisce il numero di campioni
    # in fase di training avrò n_campioni = n_img * patch_per_img
    # in fase di test e validazione avrò n_campioni = n_img
    def __len__(self):
        if self.mode == DATASET_TRAIN_STR:
            return len(self.hr_patches)
        else:
            return len(self.hr_imgs)
        
    def __getitem__(self, idx):
        if self.mode == DATASET_TRAIN_STR:
            return self.lr_patches[idx], self.hr_patches[idx]

        # Nel test set SET5 e SET14, le foto hanno stessa dimensione, faccio un downscaling
        # per poi rifare up-sampling fuori
        # Lavoro solo su una foto HR perché sono in modalità test
        if self.mode == DATASET_TEST_STR:
            hr = self.hr_imgs[idx]
            
            # Crea LR artificialmente: downscale ÷2
            hr_w, hr_h = hr.size
            lr_w, lr_h = hr_w // self.scale, hr_h // self.scale
            lr = hr.resize((lr_w, lr_h), Image.BICUBIC)
            
            # Pre-upsampling: riporta a dimensione HR
            lr = lr.resize((hr_w, hr_h), Image.BICUBIC)
            
            # Converti in tensore
            lr_tensor = self.to_tensor(lr)
            hr_tensor = self.to_tensor(hr)
            
            return lr_tensor, hr_tensor



        # LR già in RAM, HR caricata dal disco on-demand
        lr = self.lr_imgs[idx]
        hr = self.hr_imgs[idx]

        # Pre-upsampling in caso di validation set
        hr_w, hr_h = hr.size
        lr = lr.resize((hr_w, hr_h), Image.BICUBIC)
             
        lr_tensor = self.to_tensor(lr)
        hr_tensor = self.to_tensor(hr)

        return lr_tensor, hr_tensor
    
    def _build_patches(self):
        # Converto in Y, Cb, Cr, mi serve solo il canale Y della luminanza
        self.lr_imgs = [Image.open(p).convert('YCbCr') for p in self.lr_paths]
        self.hr_imgs = [Image.open(p).convert('YCbCr') for p in self.hr_paths]


        for hr, lr in  zip(self.hr_imgs, self.lr_imgs):

            w, h = hr.size

            for _ in range(self.patches_per_img):
                x_cord: int = random.randint(0, w - self.patch_size)
                y_cord: int = random.randint(0, h - self.patch_size)

                # tengo conto dello scaling factor per le immagini LR
                x_cord_scaled: int = x_cord // self.scale
                y_cord_scaled: int = y_cord // self.scale

                patch_size_scaled = self.patch_size // self.scale

                # Ritaglio le patch ed estraggo il canale Y, luminanza
                hr_patch = hr.crop((x_cord, y_cord, x_cord + self.patch_size,
                                    y_cord + self.patch_size))
                lr_patch = lr.crop((x_cord_scaled,
                            y_cord_scaled,
                            x_cord_scaled + patch_size_scaled,
                            y_cord_scaled + patch_size_scaled))
            
                # faccio pre-upsampling fuori dalla rete
                lr_patch = lr_patch.resize((self.patch_size, self.patch_size), Image.BICUBIC)

                self.hr_patches.append(self.to_tensor(hr_patch))
                self.lr_patches.append(self.to_tensor(lr_patch))

        # Tolgo dalla memoria le immagini originali, ho già le patch create
        self.hr_imgs = None
        self.lr_imgs = None