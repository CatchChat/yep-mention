class AES256
  class << self
    def encrypt_id(id)
      cipher = OpenSSL::Cipher::AES.new(256, :CBC)
      cipher.encrypt
      cipher.key = ENV['AES256_KEY']
      cipher.iv  = ENV['AES256_IV']
      result = cipher.update(id.to_s) << cipher.final
      result.unpack('H*').first
    end

    def decrypt_id(encrypted_id)
      cipher = OpenSSL::Cipher::AES.new(256, :CBC)
      cipher.decrypt
      cipher.key = ENV['AES256_KEY']
      cipher.iv  = ENV['AES256_IV']
      result = cipher.update([encrypted_id].pack('H*')) << cipher.final
      result.to_i rescue nil
    end
  end
end
