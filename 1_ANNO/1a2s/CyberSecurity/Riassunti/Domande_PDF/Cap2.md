# 1) List and briefly define categories of security services.  

- Authentication: Recognize if a an entity is allowed to send messages or access a resource  
- Confidentiality: Ensure that a messages between receiver and sender CANNOT be read by a third party  
- Access Control: Make sure that authorized entites can access to shared resources on a system  
- Authenticity: Ensure that a messagges is in fact sent by the sender.  
- Integrity: Make sure that the message is sent without modification (errors, or noise over the channel)
- Non-repudiation: A sender can't deny to have sent a message, or a receiver can't deny to have received the message  

# 3) What is the difference between a block cipher and a stream cipher?  

A block cipher splits the plaintext into  blocks of the same size, for example
a byte (8 bits), and then ciphers one block at the time using the encrpytion function and the secret key  

A stream cipher works directly on every single character, or bit, of the plain text,
it encrpyts them using the encryption function and the key, they are called stream cipher
because they work directly with the sequence of characters or the sequence of bits.  

# 4) List and briefly define types of cryptanalytic attacks based on what is known to the attacker.  

We can always assume that the attacker knows the encryption algorithm.
The attacker goal is to retrieve the secret key, without the secret key the attacker 
can't decrypt the cipher text into the plain text.

- Cipher Text: This is the most difficult for the attacker, he only knows the cipher text 
wich won't reveal much information

- Plain text: The attacker knows the encryption algorithm and some pairs of plain text and cipher text.

- Chosen Plain text: The attacker can target a specific plain text in order to retrieve the secret key
for this the attack also need the cipher text.

- Chosen Cipher text: The attacker can target a specific cipher text in order to retrieve the secret key
for this the attack also need the plain text.

- Statistical attacks: If the attacker knows the language of the plain text: the english language fore example, it can study the frequency of some words of combination of letters if the encryption algorithm doesn't take into consideration this kind of attack.


# 5) What is the difference between an unconditionally secure cipher and a computationally secure cipher?

**Unconditionally secure cipher**: it cannot be broken even with theoretically infinite time and computational 
resources; an example of a unconditioanlly secure cipher is  
the OTP (One Time Pad), the secret key has the same length of the  
plain text and it a one use for that message, meaning that can be reused for encrpyting other plain text.

**Computationally secure cipher**: it requires a lot of time to break the cipher even with the best equipment available, for example it can require millions of years to break it, thus the attacker won't try an attack at the cipher.

# 6) Briefly define the monoalphabetic cipher.

A monoalphabetic cipher works by assigning to a specific charcater/letter in our alphabet
a different letter of such alphabet. If we were to have a 26 letters alphabet, we would have
potentially 26! number of secret keys, counting all possible permutations.
The number of key is really high, but this doens't make it safe, since a cryptoanalyst 
could find the frequencies of letters and words an then retrieve the secret key.

# 7) What is the avalanche effect for an encryption algorithm?

The avalanche effect ensures that a minimal change in the plain text, changing a character
or a single bit, results in a high change in the cipher text, making it harder for a 
cryptoanalyst to discover the secret key. Every good cipher has a strong avalanche effect.

# 8) Which of the following block cipher modes of operation ECB, CBC, OFB, CFB, CTR, use only the encryption function for both encryption and decryption

The only modes that use the encryption functions are OFB, CFB, and CTR

**OFB (Output FeedBack Mode)**: Uses an initalization vector for the first plain text block.
and then cipher text C1 is obtained by: P1 XOR E(K, IV) for the first plain text block.
The output of E(K, IV) is then passed to the next encryption E(K, E(K, IV))

**CFB (Cipher Feedback Mode)**: Also uses an IV, the Ci (Cipher text block i_th)
is used as the input for the next Encrpyion(K, Ci). it also involes the use of a shift register.

**CTR (Counter Block Mode)**: Instead of using an IV or other Ci blocks, it uses a counter unique for 
every plain text block. E(K, Tj) Tj is the counter.