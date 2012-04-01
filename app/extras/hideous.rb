class Hideous
  MAXID =         562949953421311   # (2**49 - 1)
  PRIME =         26096431117637    #The 874,054,030,204th prime is 26,096,431,117,637.
  PRIME_INVERSE = 91990477149581    #another big integer number so that (PRIME * PRIME_INVERSE) & MAXID == 1
  RNDXOR =        432898291034718   #some random big integer number, just not bigger than MAXID

  def self.hide(bare_integer)
    (((bare_integer * PRIME) & MAXID) ^ RNDXOR).to_s(36)
  end

  def self.bare(hide_integer)
    ((hide_integer.to_i(36) ^ RNDXOR) * PRIME_INVERSE) & MAXID
  end
=begin  
  def self.inverse
    prime_inverse = modinv(PRIME,MAXID+1)
    p "Test "+((PRIME*PRIME_INVERSE) & MAXID ).to_s
  end
  
  private
  # Modular inverse
  # Returns x so that ax = 1 (mod m)
    def self.modinv(a, m)
      x, y, g = egcd(a, m)
      if g==1
        return x%m
      else
        return nil
      end
    end

    # Extended great common divisor
    # Returns x, y and gcd(a,b) so that ax + by = gcd(a,b)
    def self.egcd(a, b)
      x, x1, y, y1 = 1, 0, 0, 1
      while b!=0
        q = a/b
        x, x1 = x1, x-q*x1
        y, y1 = y1, y-q*y1
        a, b  =  b, a-q*b
      end
      return x, y, a
    end    
=end    
end