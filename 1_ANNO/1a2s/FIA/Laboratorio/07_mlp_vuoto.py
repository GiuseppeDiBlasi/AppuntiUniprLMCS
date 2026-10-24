import sys

import random

import numpy as np

import pandas as pd

import data_loader

def relu(x):
    return np.maximum(0, x)

def relu_prime(x):
    return np.where(x > 0, 1, 0)

def sigmoid(x):
    return 1.0 / (1.0 + np.exp(-x))

def sigmoid_prime(x):
    s = sigmoid(x)
    return s * (1 - s)

class Network(object):

    # Costruttore 
    def __init__(self, sizes, eta): # Dimensione degli strati e learning rate
        self.sizes = sizes
        self.eta = eta

        # Numero layer interni, esclusi input e output
        self.numLayer = len(sizes) - 2
        
        # Vettori di bias, per tutti gli strati tranne input
        self.bias = [np.random.randn(n, 1) for n in sizes[1:]]


        self.weigths = [np.random.randn(a, b) for a, b in zip(sizes[:-1], sizes[1:])]

        self.activation_functions = [sigmoid for _ in range(self.numLayer + 1)]
        self.activation_functions[-1] = sigmoid 

        self.activation_functions_prime = [
            sigmoid_prime for _ in range(self.numLayer + 1)
        ]
        self.activation_functions_prime[-1] = sigmoid_prime



    def pre_activation(x, w, b):
        return np.dot(x, w) + b

    # Attivazione input su tutti gli strati
    def forward(self, x):
        a = [x] # attivazioni
        pa = [0] # pre-attivazioni

        i = 0

        # Prestare attenzione alle dimensioni delle matrici e vettori

        for W, b in zip(self.weigths, self.bias):
            # 784 x n, 784 x 1
            pa.append(np.dot(np.transpose(W), a[-1]) + b)

            pa.append(self.activation_functions[i](pa[-1]))
            i += 1

        return a, pa



    # Algoritmo di back propagation
    # a, attivazioni
    # pa, pre-attivazioni
    # y del dataset
    def backward(self, a, pa, y): 
        #err_output = (a[-1] - y) * self.activation_functions_prime[-1](
        #   self.activation_functions_prime[-1](pa[-1])
        #) 

        #err_layer = []

        delta = [np.zeros((n, 1)) for n in self.sizes[1:]]

        # strato di output, come nella definizione in lezione 5
        delta[-1] = (a[-1] - y) * self.activation_functions_prime[-1](pa[-1])

        for l in range(self.numLayer -1, -1, -1):
            # n x 10 è la matrice dei pesi
            # delta 10, 1
            # ------> n x 1
            delta[l] = np.dot(self.weigths[l + 1], delta [l + 1]) * self.activation_functions_prime[l + 1](pa[l + 1])



        return delta 

    # Algoritmo discesa del gradiente
    def step(self, activations, deltas):   

        # 784 x n, n x n_2, n_2 x 10     
        gradient_W = [np.zeros(w.shape) for w in self.weigths]
        gradient_b = [np.zeros(b.shape) for b in self.bias]

        num_input = len(activations)

        for l in range(self.numLayer, -1, -1):
            sum_w = 0
            for k in rnage(num_input):

                # attivazione strato output
                # attivazione 10 x 1
                # delta (errore) strato di output
                # delta 10 x 1

                sum_w += np.dot(activations[k][l], np.transpose(deltas[k][l]))

            sum_b = 0

            for k in range(num_input):
                sum_b += deltas[k][l]

            gradient_W[l] = sum_w
            gradient_b[l] = sum_b

        # Discesa del gradiente
        self.weigths = [
            w - (self.eta / num_input) * dw
            for w, dw in zip(self.weigths, gradient_W)
        ]

        self.bias = [
            b - (self.eta / num_input) * db
            for b, db in zip(self.bias, gradient_b)
        ]


    
    def test(self, test_data):
        
        count = 0

        for x, y in test_data:
            
            a, _ = self.forward(x)

            output = a[-1]

            if output.shape == y.shape:
                if (np.round(output) == y).all():
                    count += 1
            else:
                if np.argmax(output) == y:
                    count += 1

        return count



    def train(self, training_data, test_data, n_epochs, mini_batch_size):
        pass



def main(ARGS):

    try:
        mode = ARGS[0]
    except:
        mode = "mnist"

    if mode == "xor4":
        training_data, test_data = data_loader.load_xor_4bit_data()

    elif mode == "xor8":
        training_data, test_data = data_loader.load_xor_8bit_data()

    else:
        training_data, _, test_data = data_loader.load_data_wrapper()

    # train network

    # define network

    # 784, dimensione strato di input
    # 10, neuroni di output
    # K, strato nascosto
    K = int(784 // 2)

    net = Network([784, K,  10], 0.01)

    return 0

if __name__ == "__main__":

    ARGS = sys.argv[1:]

    RETCODE = main(ARGS)

    sys.exit(RETCODE)