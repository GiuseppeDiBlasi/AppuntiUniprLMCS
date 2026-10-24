import math
from torch import nn

class SRResNet(nn.Module):
    def __init__(self, kernel_size=3, n_channels=64, n_blocks=16, scaling_factor=2):
        super(SRResNet, self).__init__()
        self.conv_block1 = ConvolutionalBlock(in_channels=3, out_channels=n_channels, kernel_size=kernel_size, activation=None)
        self.residual_blocks = nn.Sequential(*[ResidualBlock(kernel_size=kernel_size, n_channels=n_channels) for _ in range(n_blocks)])
        self.conv_block2 = ConvolutionalBlock(in_channels=n_channels, out_channels=n_channels, kernel_size=kernel_size, activation=None)
        log_scaling_factor = int(math.log2(scaling_factor))
        self.pixelshuffle_convolutional_blocks = nn.Sequential(*[PixelShuffleConvolutionalBlock(kernel_size=kernel_size, n_channels=n_channels, scaling_factor=2)
                                                            for _ in range(log_scaling_factor)])
        self.conv_block3 = ConvolutionalBlock(in_channels=n_channels, out_channels=3, kernel_size=kernel_size, activation=None)

    def forward(self, lr_imgs):
        output = self.conv_block1(lr_imgs)
        residual = output
        output = self.residual_blocks(output)
        output = self.conv_block2(output)
        output = output + residual
        output = self.pixelshuffle_convolutional_blocks(output)
        sr_imgs = self.conv_block3(output)

        return sr_imgs
    
class ResidualBlock(nn.Module):
    def __init__(self, kernel_size=3, n_channels=64):
        super(ResidualBlock, self).__init__()
        self.conv_block1 = ConvolutionalBlock(in_channels=n_channels, out_channels=n_channels, kernel_size=kernel_size, activation='ReLu')
        self.conv_block2 = ConvolutionalBlock(in_channels=n_channels, out_channels=n_channels, kernel_size=kernel_size, activation=None)

    def forward(self, input):
        residual = input
        output = self.conv_block1(input)
        output = self.conv_block2(output)
        output = output + residual

        return output

class ConvolutionalBlock(nn.Module):
    def __init__(self, in_channels, out_channels, kernel_size, stride=1, activation=None):
        super(ConvolutionalBlock, self).__init__()
        layers = list()
        layers.append(nn.Conv2d(in_channels=in_channels, out_channels=out_channels, kernel_size=kernel_size, stride=stride, padding=kernel_size // 2))
        if activation == 'ReLu':
            layers.append(nn.ReLU())
        self.conv_block = nn.Sequential(*layers)

    def forward(self, input):
        output = self.conv_block(input)

        return output

class PixelShuffleConvolutionalBlock(nn.Module):
    def __init__(self, kernel_size=3, n_channels=64, scaling_factor=2):
        super(PixelShuffleConvolutionalBlock, self).__init__()
        # A convolutional layer that increases the number of channels by scaling factor^2
        self.conv = nn.Conv2d(in_channels=n_channels, out_channels=n_channels * (scaling_factor ** 2),
                              kernel_size=kernel_size, padding=kernel_size // 2)
        # The additional channels are shuffled to form additional pixels, upscaling each dimension by the scaling factor
        self.pixelShuffle = nn.PixelShuffle(upscale_factor=scaling_factor)

    def forward(self, input):
        output = self.conv(input)
        output = self.pixelShuffle(output)

        return output