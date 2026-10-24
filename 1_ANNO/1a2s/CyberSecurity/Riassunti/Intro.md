# Cybersecurity

## Objective

The objective of cybersecurity is making a system, like a computer, software, network, etc..)
secure. There three types of security:

- Physical Security:
    - The access to the system is phisycally limited:
    We lock the server behind a door and only people with the key can access it.
    We can use cameras, card readers and biometric data to allow authorized people to
    access the system.

    - Avoid information leakage:
    Shredding sensitive documents before they are thrown away

- Technological security:
    - Communication and data security (safe communication protocols)
    - Software security:
        Application security (Avoid software vulnerabilities)
        OS Security (Use up to date OS)

- Good policies and practices on how to use the system

## Security service

It enhances the system security and the information transfer.

- It aims at protecting data, system and user information
- Intends to counter security attacks

A security service can make use of one or more security mechanism to provide the
service.

It replicates functions that are normally associated with a physical object:

- Signatures
- Dates
- Proof of reception
- Notarization
- Recording

Some example of security services are:

- Confidentiality
- Data integrity and authenticity (message authentication)
- Identification (Peer entity authentication)
- Authorization and access control
- System integrity and availability
- Accountability and non-repudiation
- Anonymity

### Confidentiality

It protects data from unauthroized entinties, only authorized entities can access
the information.
It is related to data confidentiality and anonymity

### Data integrity

It ensures that data has not changed, destroyed or lost in an unauthorized or accidental manner.
It protects against change in data by ensuring that such changes are detectable.
It general it only detects a change

### Data origin authentication

Provides for the corroboration of the source of a data unit

- Confirms who sent a piece of data
This service allows to verify the identity o a system entity that is claimed to be
the original source of received data.

It is usually provided along side with data integrity.

### Message authentication (authenticity)

It offser both data integrity and authentication.
In general, authenticity implies integrity, but not viceversa.


### Identification (Peer entity authentication)

It allows to verifiy the identity of a peer entity, this is done before establishing
communication for example or before giving access to a resource or service.

### Authorization and access control

- Authorization (manages access rights privilages):
    Verify if the entity has the right permission to access to a specific system resource

- Access control:
    Ability to limit and control access to a system
    It protectes the system against unauthorized access

### System integrity

It's the quality that a system has when perfomring its operations.
It protectes the system against unautorized changes, loss or destruction

### Availability

Protect the system in order to ensure its availability.
Protect the system against DoS attacks.

### Accountability and non-repudiation

- Accountability and audit:

Accountability refers to the ability to trace to specific users or entities.
Audit refers to the process of reviewing and analyzing logs, records or actions logged
by the accountability.

- Non repudiation:

Provides protection against false denial of an action.
It provides evidence that can be stored and later presented to a third party.

In a case of communication it prevents the sender or receiver to deny whether they
send or received the message.

The sender can prove that the receiver, in fact received the message
-> non repudiation with proof of receipt.

The receiver can prove that the receiver, in fact sent the message
-> non repudiation with proof of origin.

## Security mechanism

These security services are provided by means of different security functions / mechanisms
They can be included in appropriate communication layer.

Some examples:

- Authentication exchange
- Data integrity
- enciphering
- Digital signature
- Notorization (Third party authentication)
- Access control
- Routing control
- Traffic padding
