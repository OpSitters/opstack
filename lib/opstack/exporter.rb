module OpStack
  class Exporter
    def run(prefix, hash)
      _traverse(prefix, hash)
    end

    private

    def _traverse(prefix, hash)
      hash.each do |key, val|
        key_name = "#{prefix}_#{key}".upcase
        if val.is_a?(Hash)
          _traverse(key_name,val)
        else
          _export(key_name, val)
        end
      end
    end

    def _export(var, val)
      puts "export #{var}='#{val}'"
    end
  end
end
