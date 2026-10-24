import random
import numpy as np

random.seed(42)

gamma = ["A", "C", "G", "T"]

random.seed(42)

w_len = 5
word = ""

for i in range(w_len):
    word = word + random.choice(gamma)

k = 2
d = dict()
# bag of words vuol dire insieme
for i in range(len(word) - k + 1):
    d[word[i : i + k]] = d.get(word[i : i + k], 0) + 1

print(word)
print(d)
