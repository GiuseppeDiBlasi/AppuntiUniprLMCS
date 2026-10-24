# Data una parola, stampare tutte le possibili permutazioni.

solutions = set()
iters: int = 0


def generate_permutation(current_permutation, remaining_letters):
    global iters

    iters += 1

    if len(remaining_letters) == 0:
        solutions.add(current_permutation)
        return

    used_letters = set()

    for c in remaining_letters:
        if c in used_letters:
            continue

        used_letters.add(c)

        new_remaining_letters = remaining_letters.copy()
        new_remaining_letters.remove(c)

        generate_permutation(current_permutation + c, new_remaining_letters)


def generate_permutation_iterative(str_start, letters_list):
    global iters
    stack = []

    # Primo stato nello stack
    stack.append((str_start, letters_list))

    while len(stack) > 0:
        iters += 1
        current_permutation, remaining_letters = stack.pop()

        if len(remaining_letters) == 0:
            solutions.add(current_permutation)
            continue

        used_letters = set()

        for c in remaining_letters:
            if c in used_letters:
                continue

            used_letters.add(c)

            new_permutation = current_permutation + c
            new_remaining_letters = remaining_letters.copy()
            new_remaining_letters.remove(c)

            stack.append((new_permutation, new_remaining_letters))


def main():
    word: str = input("Inserire parola:")

    letters_list = list(word)

    # generate_permutation("", letters_list)

    generate_permutation_iterative("", letters_list)

    print("Iterations:" + str(iters) + "; Solutions:\n", solutions)


main()
