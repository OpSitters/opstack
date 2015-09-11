require 'securerandom'
require 'fileutils'
require 'yaml'

module OpStack
  @@config = {
    :config_dir => "#{Dir.home}/.opstack",
    :secret_file => ".accounts_key",
    :export_prefix => "OPSTACK"
  }

  @@secret = nil

  def self.secret()
    confdir = File.dirname(@@config[:config_dir])
    secret_file = "#{confdir}/#{@@config[:secret_file]}"

    FileUtils.mkdir_p(confdir)
    unless File.exist?(secret_file)
      secret_key = SecureRandom.urlsafe_base64(512, true)
      File.write(secret_file, secret_key)
    end
    unless @@secret
      @@secret = File.read(secret_file)
    end
    @@secret
  end

  def self.config
    @@config
  end


end


