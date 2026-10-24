import random
import numpy as np

random.seed(42)

gamma = ["A", "C", "G", "T"]

prob = [33, 33, 17, 17]

w_len = 1000
word = ""

for i in range(w_len):
    word = word + random.choice(gamma)

# print(word)

isto = dict()

for k in gamma:
    isto[k] = word.count(k)

print(isto)

values = [a for a in isto.values()]
print(np.std(values) / np.mean(values))
