import random
from PIL import Image
from pathlib import Path
from torch.utils.data import Dataset
import torchvision.transforms as transforms

class DIV2KDataset(Dataset):
    def __init__(self, hr_dir, lr_dir, split, crop_size, scaling_factor):
        self.split = split.lower()
        self.crop_size = crop_size
        self.scaling_factor = scaling_factor
        assert self.split in {"train", "test"}

        self.hr_images = sorted(Path(hr_dir).glob("*.png"))
        self.lr_images = sorted(Path(lr_dir).glob("*.png"))

        self.transform = Transform(split=self.split,
                                   crop_size=self.crop_size,
                                   scaling_factor=self.scaling_factor)

    def __getitem__(self, i):
        hr_img = Image.open(self.hr_images[i], mode='r')
        lr_img = Image.open(self.lr_images[i], mode='r')
        hr, lr = self.transform(hr_img, lr_img)

        return hr, lr

    def __len__(self):
        # print("hr_images: {hr_images}, lr_images: {lr_images}".format(hr_images=len(self.hr_images), lr_images=len(self.lr_images)))
        assert len(self.hr_images) == len(self.lr_images)
        assert len(self.hr_images) != 0

        return len(self.hr_images)
    
class Transform(object):
    def __init__(self, split, crop_size, scaling_factor):
        self.split = split
        self.crop_size = crop_size
        self.scaling_factor = scaling_factor

    def __call__(self, hr_img, lr_img):
        if self.split == "train":
            w, h = hr_img.size
            x: int = random.randint(0, w - self.crop_size)
            y: int = random.randint(0, h - self.crop_size)
            # Tengo conto dello scaling factor per le immagini LR
            x_scaled: int = x // self.scaling_factor
            y_scaled: int = y // self.scaling_factor
            crop_size_scaled = self.crop_size // self.scaling_factor
            hr_img = hr_img.crop((x, y, x + self.crop_size, y + self.crop_size))
            lr_img = lr_img.crop((x_scaled, y_scaled, x_scaled + crop_size_scaled, y_scaled + crop_size_scaled))

        transform = transforms.ToTensor()   # Converte le immagini in tensori e normalizza [0, 255] -> [0, 1]

        # Non funziona con X8
        assert hr_img.width == lr_img.width * self.scaling_factor and hr_img.height == lr_img.height * self.scaling_factor

        hr_img = transform(hr_img)
        lr_img = transform(lr_img)

        return hr_img, lr_img