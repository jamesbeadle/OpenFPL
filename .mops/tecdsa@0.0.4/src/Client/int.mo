import { btstNat8; natToNat8; abs } "mo:⛔";

module {

  public func pow_mod(base: Int, exponent: Int, modulus: Int ) : Int {
    var result: Int = 1;
    var base_ = base;
    var exponent_ = exponent;

    base_ := base_ % modulus;
    while (exponent_ > 0){
      if(exponent_ % 2 == 1) result := (result * base_) % modulus;
      exponent_ := exponent_ / 2;
      base_ := (base_ * base_) % modulus
    };
    return result;
  };

  public func modulo(num: Int, modulus:Int): Int {
    var result = num % modulus;
    if(result < 0) result += modulus;
    return result;
  };

  func calcSize(n: Int): Nat {
    func rec(i: Nat): Nat {
      if (((256 ** i) - 1: Nat) >= n) i else rec(i+1)
    }; 
    rec(1)
  };

  type GenFn = Nat -> Nat8;

  public func generate(size: Nat, generator: GenFn): Int {
    func evaluate(num: Nat, byte: Nat8, bit: Nat8): Nat {
      if (btstNat8(byte, bit))
        if (bit != 0x00) evaluate(num*2+1, byte, bit-1)
        else num * 2 + 1
      else 
        if (bit != 0x00) evaluate(num*2, byte, bit-1)
        else num * 2
    };
    func sum(num: Nat, cnt: Nat): Nat {
      if (cnt == size) num
      else sum(
        evaluate(num, generator(cnt), 0x07),
        cnt+1
    )};
    sum(0,0)
  };

  public func generator(n: Int): (Nat, GenFn) {
    var q: Int = n;
    var b: Nat = calcSize(n);
    func genFn(i: Nat): Nat8 {
      if (i >= b) return 0xFF;
      func rec(count: Nat, div: Nat, byte: Nat8): Nat8 {
        if (q == 0 or count == 8) return byte;
        if (q / div == 1){ q %= div; rec(
          count + 1,
          2 ** (((b-i)*8) - (count+1)) / 2,
          byte | 1 << natToNat8(7-count)
        )} else rec(
          count + 1,
          2 ** (((b-i)*8) - (count+1)) / 2,
          byte
      )};
      rec(0, 2**((b-i)*8)/2, 0x00)
    };
    (b, genFn)
  };

};