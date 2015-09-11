module OpStack
  module Environment
    class Chef

      def export(environment)
        config=OpStack.config
        secret=OpStack.secret
        prefix = config[:export_prefix]
        databag_file = "#{config[:config_dir]}/environments/#{environment}/accounts.json"

        begin
          encrypted_data = JSON.parse(File.read(databag_file))
          data_bag = ::Chef::EncryptedDataBagItem.new(encrypted_data, secret).to_hash
        rescue Errno::ENOENT
          OpStack.logger.error("Environment #{environment} Not Found."); return nil
        rescue JSON::ParserError
          OpStack.logger.error("Could not Parse #{databag_file}"); return nil
        rescue ::Chef::EncryptedDataBagItem::DecryptionFailure
          OpStack.logger.error("Could not decrypt #{databag_file}"); return nil
        end
        
      end

      def import(environment, file)
        config=OpStack.config
        secret=OpStack.secret
        prefix = config[:export_prefix]
        databag_file = "#{config[:config_dir]}/environments/#{environment}/accounts.json"

        begin
          data = JSON.parse(File.read(file))
          encrypted_data = ::Chef::EncryptedDataBagItem.encrypt_data_bag_item(data, secret)
          File.write(databag_file, JSON.pretty_generate(encrypted_data))
        rescue Errno::ENOENT
          OpStack.logger.error("File #{file} Not Found."); return nil
        rescue ::Chef::EncryptedDataBagItem::EncryptionFailure
          OpStack.logger.error("Could not encrypt the data"); return nil
        end
      end

    end
  end
end
