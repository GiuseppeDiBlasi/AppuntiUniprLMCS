
// Ritorna (gcd, x, y) tale che a*x + b*y = gcd
fn extended_gcd(a: i64, b: i64) -> (i64, i64, i64) {
    if b == 0 {
        (a, 1, 0)
    } else {
        let (gcd, x, y) = extended_gcd(b, a % b);
        (gcd, y, x - (a / b) * y)
    }
}

// Inverso moltiplicativo di e mod phi
// Ritorna None se l'inverso non esiste (gcd != 1)
fn mod_inverse(e: i64, phi: i64) -> Option<i64> {
    let (gcd, x, _) = extended_gcd(e, phi);
    if gcd != 1 {
        None // e e phi non sono coprimi, inverso non esiste
    } else {
        // x potrebbe essere negativo, lo rendiamo positivo
        Some(((x % phi) + phi) % phi)
    }
}


fn gcd(a: u64, b: u64) -> u64 {
    if b == 0 { a } else { gcd(b, a % b) }
}

fn select_e(phi_n: u64) -> u64{
    let mut e = 3u64;

    // Numeri pari non sono mai coprimi
    while (e < phi_n)  {

        if gcd(e, phi_n) == 1{
            return e;
        }

        e += 2;
    }

    panic!("nessun e valido trovato");
}

fn generate_keys(p: u64, q: u64) -> [u64; 3] {
    let n = p * q;

    let phi_n = (p - 1) * (q - 1);

    let e: u64 = select_e(phi_n);

    let d: u64 = mod_inverse(e as i64, phi_n as i64).unwrap() as u64;

    return [n, e, d];

}

fn mod_pow(mut base: u64, mut exp: u64, modulus: u64) -> u64 {
    let mut result = 1u64;
    base %= modulus;

    while exp > 0 {
        if exp % 2 == 1 {
            result = result * base % modulus;
        }
        exp /= 2;
        base = base * base % modulus;
    }
    result
}

fn cipher_message(block: u64, e: u64, n: u64) -> u64{
    mod_pow(block, e, n)
}

fn decypher_message(block: u64, d: u64, n: u64) -> u64{
    mod_pow(block, d, n)
}

fn main() {

    let keys: [u64; 3] = generate_keys(7, 11);

    let n = keys[0];
    let e = keys[1];
    let d = keys[2];

    let M: [u64; 3] = [2, 4, 3];

    let mut C: [u64; 3] = [0; 3];

    println!("M: {:?}", M);

    for (i, m_i) in M.iter().enumerate() {
        C[i] = cipher_message(*m_i, e, n);
    }

    println!("C: {:?}", C);

    let mut res: [u64; 3] = [0; 3];

    for (i, c_i) in C.iter().enumerate() {
        res[i] = decypher_message(*c_i, d, n);
    }

    println!("Res: {:?}", res);
    
}
