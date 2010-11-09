class Base64Url
  BASE64 = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_'
  
  def self.encode(n)
    n = n.to_i
    return 'A' if n == 0
    val = ''
    until n == 0 do
      val = BASE64[n % 64].chr + val
      n /= 64
    end
    return val
  end
  
  def self.decode(s)
    s = s.to_s
    val = 0
    until s == '' do
      val *= 64
      val += BASE64.index(s[0])
      s = s[1..-1]
    end
    return val
  end
end