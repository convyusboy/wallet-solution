require "openssl"
module ApplicationHelper
  def token_mask(prefix, length = 30)
    "#{prefix}#{"•"*length}"
  end

  def encrypt(plain_text, key = "secret")
    cipher = OpenSSL::Cipher.new("aes-256-cbc").encrypt
    cipher.key = Digest::MD5.hexdigest key
    s = cipher.update(plain_text) + cipher.final

    s.unpack("H*")[0].upcase
  end

  def decrypt(cipher_text, key = "secret")
    cipher = OpenSSL::Cipher.new("aes-256-cbc").decrypt
    cipher.key = Digest::MD5.hexdigest key
    s = [ cipher_text ].pack("H*").unpack("C*").pack("c*")

    cipher.update(s) + cipher.final
  end
end
