from collections import namedtuple
import pdb

Transition = namedtuple('Transition', ['start', 'char', 'dest'])


STATES_TAG = "STATES" # mode 1
ALPHABET_TAG = "ALPHABET" # mode 2
INITIAL_TAG = "INITIAL" #  mode 3
FINAL_TAG = "FINAL" # mode 4
TRANSITIONS_TAG = "TRANSITIONS" # mode 5

class MODE:
    READ_MODE: int = 0
    STATES_MODE: int = 1 
    ALPHABET_MODE: int = 2
    INITIAL_MODE: int = 3
    FINAL_MODE: int = 4
    TRANSITION_MODE: int = 5

states = []
alphabet = []
initial = []
accepting_states = []
transitions = []

def printData():
    print("States: " + str(states)) 
    print("Alphabet: " + str(alphabet))
    print("Initial state: " + str(initial))
    print("Accepting states: " + str(accepting_states))
    print("Transitions: " + str(transitions))

def addData(mode: int, line):
    global states
    global alphabet
    global initial
    global final
    global transitions

    line = line.strip()

    if len(line) == 0:
        return

    match mode:
        case MODE.STATES_MODE:
            states.append(line.strip())
        case MODE.ALPHABET_MODE:
            alphabet.append(line.strip())
        case MODE.INITIAL_MODE:
            initial.append(line.strip())
        case MODE.FINAL_MODE: 
            accepting_states.append(line.strip())
        case MODE.TRANSITION_MODE:
            elements = line.split()
            transitions.append(Transition(elements[0],
                                    elements[1],  # corretto: elemnts -> elements
                                    elements[2]))

def loadDFA():
  
    mode: int = 0

    with open("./dfa5.txt", "r") as f:
        for line in f:            
             
            if len(line) == 0 or line.startswith("#"):
                mode = MODE.READ_MODE
                continue

            if STATES_TAG in line:
                mode = MODE.STATES_MODE             
                continue

            if ALPHABET_TAG in line:
                mode = MODE.ALPHABET_MODE
                continue

            if INITIAL_TAG in line:
                mode = MODE.INITIAL_MODE
                continue

            if FINAL_TAG in line:
                mode = MODE.FINAL_MODE
                continue

            if TRANSITIONS_TAG in line:
                mode = MODE.TRANSITION_MODE
                continue

            if mode != MODE.READ_MODE:
                addData(mode, line)


def delta_inversa(s, alpha):
    #Calcolare la funzione di transizione inversa per il simbolo alpha
    #Restituisce l'insieme di tutti gli stati s che si possono raggiungere tramite alpha

    result = set()

    pdb.set_trace()

    for t in transitions:
        if t.dest == s and t.char == alpha:
            result.add(t.start)

    return result

def hopcroftMinimization():
    # F stati accettanti
    # S - F, stati non finali

    pdb.set_trace()

    F = set(accepting_states)
    S_F = set(states) - F 

    W = []
    P = []

    if len(F) > 0:
        W.append(F)
        P.append(F)

    if len(S_F) > 0:
        W.append(S_F)
        P.append(S_F)

    #while (W is not empty) do begin
    while len(W) > 0:

        # select and remove s from W
        s = W.pop(0)
        pdb.set_trace()
        # for each alpha in alphabet
        for alpha in alphabet:
            I_alpha = set()

            # let I_alpha <- delta_inversa(s)
            for state in s:
                I_alpha = I_alpha.union(delta_inversa(state, alpha))

            pdb.set_trace()

            # for each p ∈ P such that p ∩ I_α is not empty and p is not contained in I_alpha            
            new_P = []

            for p in P:
                p_intersect_I = p.intersection(I_alpha)

                # Se l'interesezione è vuota o p è contenuto in I_alpha, non fare split
                if len(p_intersect_I) == 0 or p.issubset(I_alpha):
                    new_P.append(p)
                else:
                    # partition p into p1 and p2 such that p1 <- ∩ I_alpha; p2 ← p - p1
                    p1 = p_intersect_I
                    p2 = p - p1
                    
                    # P ← (P - p) ∪ p1 ∪ p2
                    new_P.append(p1)
                    new_P.append(p2)
                    
                    # if p ∈ W
                    if p in W:
                        # then W ← (W - p) ∪ p1 ∪ p2
                        W.remove(p)
                        W.append(p1)
                        W.append(p2)

                    else:
                        # else if |p1| ≤ |p2|
                        if len(p1) <= len(p2):
                            # then W ← W ∪ p1
                            W.append(p1)
                        else:
                            # else W ← W ∪ p2
                            W.append(p2)

            
            pdb.set_trace()
            P = new_P

    # Stampa risultati
    print("\n=== DFA MINIMIZZATO (Algoritmo di Hopcroft) ===")
    print(f"Numero di stati minimizzati: {len(P)}")
    
    for i, partition in enumerate(P):
        partition_list = sorted(list(partition))
        is_initial = any(s in initial for s in partition)
        is_final = any(s in accepting_states for s in partition)
        
        print(f"\nStato {i}: {partition_list}")

        if is_initial:
            print(f"  -> Stato iniziale")
        if is_final:
            print(f"  -> Stato finale")

def main():
    loadDFA()
    printData()

    print("\n\n")

    hopcroftMinimization()


main()
