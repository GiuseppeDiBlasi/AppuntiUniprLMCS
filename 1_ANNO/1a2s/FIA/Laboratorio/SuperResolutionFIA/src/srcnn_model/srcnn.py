import torch
import torch.nn as nn

from config import *

# La rete lavora sul canale di luminanza

class SRCNN(nn.Module):
    def __init__(self):
        super(SRCNN, self).__init__()
        
        # channels = canali intermedi es. [128, 128, 64]
        # kernels  = kernel per ogni layer es. [9, 7, 7, 5]
        #            len(kernels) deve essere len(channels) + 1 (ultimo layer → 1 canale output)
        
        self.channels = CHANNELS
        self.kernels = KERNELS
        
        layers = []
        in_ch = 1  # input: canale Y
        
        for i, (out_ch, k) in enumerate(zip(self.channels, self.kernels)):
            layers.append(nn.Conv2d(in_ch, out_ch, kernel_size=k, padding=k//2))

            if BATCH_NORMALIZATION:
                layers.append(nn.BatchNorm2d(out_ch))

            layers.append(nn.ReLU())
            in_ch = out_ch
        
        # Layer finale: riduce a 1 canale, nessuna ReLU
        k_end = self.kernels[-1]
        layers.append(nn.Conv2d(in_ch, 1, kernel_size=k_end, padding=k_end//2))
        
        self.net = nn.Sequential(*layers)

    def forward(self, x):
        residual = x
        out = self.net(x)

        if RESIDUAL:
            return out + residual
        return out

    def print_architecture(self):
        ch_str = "-".join(map(str, self.channels))
        k_str  = "-".join(map(str, self.kernels))
        return f"(LY:{ch_str})_({k_str})"