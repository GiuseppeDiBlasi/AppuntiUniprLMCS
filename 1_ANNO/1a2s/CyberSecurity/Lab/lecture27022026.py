import random 

def encrypt(key, plain_text):
    cipher_text = []

    for i in range(len(plain_text)):
        cipher_text.append(plain_text[i]^keystream[i])
    
    return bytes(cipher_text)

secret_seed= b"12345"
random.seed(secret_seed)

plain_text = b"Hello World"

keystream = random.randbytes(len(plain_text))

print(keystream)

print("\n")


#Devo usare keystream.hex() perché keystream è un insime di byte e non un intero
print("m: ", keystream.hex())

cipher_text = encrypt(keystream, plain_text)
print("c: ", cipher_text.hex())
