# This code is derived from the chef encrypted data bag code found at
# https://github.com/chef/chef/tree/master/lib/chef/encrypted_data_bag_item
#
# Original Author:: Seth Falcon (<seth@opscode.com>)
# Original Copyright:: Copyright 2010-2011 Opscode, Inc.
# Original License:: Apache License, Version 2.0

module OpStack
  class Encryption
    attr_reader :key
    attr_reader :plaintext_data
    attr_reader :encrypted_data
    attr_reader :cipher

    require 'openssl'
    require 'base64'
    require 'digest/sha2'
    require 'ffi_yajl'

    ALGORITHM = 'aes-256-cbc'

    def encryptor(plaintext_data, key, iv=nil, cipher=nil)
      @plaintext_data = plaintext_data
      @key = key
      @iv = iv && Base64.decode64(iv)
      @cipher = cipher || ALGORITHM
      self
    end

    def decryptor(encrypted_hash, key)
      @encrypted_data = Base64.decode64(encrypted_hash["encrypted_data"])
      @cipher = encrypted_hash["cipher"] || ALGORITHM
      @iv = Base64.decode64(encrypted_hash["iv"])
      @key = key
      self
    end

    def iv
      openssl_encryptor if @iv.nil? and @plaintext_data
      @iv
    end

    def openssl_encryptor
      @openssl_encryptor ||= begin
        encryptor = OpenSSL::Cipher.new(cipher)
        encryptor.encrypt
        @iv ||= encryptor.random_iv
        encryptor.iv = @iv
        encryptor.key = Digest::SHA256.digest(key)
        encryptor
      end
    end

    def openssl_decryptor
      @openssl_decryptor ||= begin
        decryptor = OpenSSL::Cipher.new(cipher)
        decryptor.decrypt
        decryptor.key = OpenSSL::Digest::SHA256.digest(key)
        decryptor.iv = iv
        decryptor
      end
    end

    def encrypted_data
      @encrypted_data ||= begin
        enc_data = openssl_encryptor.update(serialized_data)
        enc_data << openssl_encryptor.final
        Base64.encode64(enc_data)
      end
    end

    def decrypted_data
      @decrypted_data ||= begin
        plaintext = openssl_decryptor.update(@encrypted_data)
        plaintext << openssl_decryptor.final
      rescue OpenSSL::Cipher::CipherError => e
        raise DecryptionFailure, "Error decrypting data bag value: '#{e.message}'. Most likely the provided key is incorrect"
      end
    end

    def encrypted_hash
      {
        "encrypted_data" => encrypted_data,
        "iv" => Base64.encode64(iv),
        "cipher" => cipher
      }
    end

    def serialized_data
      FFI_Yajl::Encoder.encode(:json_wrapper => plaintext_data)
    end

    def decrypted_hash
      FFI_Yajl::Parser.parse(decrypted_data)["json_wrapper"]
    end

  end
end
