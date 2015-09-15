module OpStack
  class Encryption
    attr_reader :key
    attr_reader :plaintext_data

    require 'openssl'
    require 'base64'
    require 'digest/sha2'
    require 'ffi_yajl'

    ALGORITHM = 'aes-256-cbc'

    def initialize(plaintext_data, key, iv=nil)
      @plaintext_data = plaintext_data
      @key = key
      @iv = iv && Base64.decode64(iv)
    end

    def iv
      openssl_encryptor if @iv.nil?
      @iv
    end

    def openssl_encryptor
      @openssl_encryptor ||= begin
        encryptor = OpenSSL::Cipher::Cipher.new(ALGORITHM)
        encryptor.encrypt
        @iv ||= encryptor.random_iv
        encryptor.iv = @iv
        encryptor.key = Digest::SHA256.digest(key)
        encryptor
      end
    end

    def serialized_data
      FFI_Yajl::Encoder.encode(:json_wrapper => plaintext_data)
    end

    def hmac
      @hmac ||= begin
        digest = OpenSSL::Digest::Digest.new("sha256")
        raw_hmac = OpenSSL::HMAC.digest(digest, key, encrypted_data)
        Base64.encode64(raw_hmac)
      end
    end

    def encrypted_data
      @encrypted_data ||= begin
        enc_data = openssl_encryptor.update(serialized_data)
        enc_data << openssl_encryptor.final
        Base64.encode64(enc_data)
      end
    end

    def for_encrypted_item
      {
        "encrypted_data" => encrypted_data,
        "hmac" => hmac,
        "iv" => Base64.encode64(iv),
        "version" => 2,
        "cipher" => ALGORITHM
      }
    end

  end
end
