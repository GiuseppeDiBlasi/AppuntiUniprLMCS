import torch
import torch.nn as nn

class VecchiaSRCNN2014(nn.Module):
    def __init__(self):
        super(VecchiaSRCNN2014, self).__init__()
        # La SRCNN 2014 classica ha esattamente questi 3 strati:
        # Configurazione corretta estratta dai pesi salvati:
        self.conv1 = nn.Conv2d(1, 64, kernel_size=9, padding=4)
        self.conv2 = nn.Conv2d(64, 32, kernel_size=5, padding=2) # <--- Cambiato da 64 a 32!
        self.convEnd = nn.Conv2d(32, 1, kernel_size=5, padding=2) # <--- Cambiato da 64 a 32!
        self.relu = nn.ReLU(inplace=True)

    def forward(self, x):
        x = self.relu(self.conv1(x))
        x = self.relu(self.conv2(x))
        out = self.convEnd(x)
        # Nota: Nel file config avevi RESIDUAL = True, ma il vecchio modello
        # non era residuo. Se vuoi testarlo senza skip connection:
        return out