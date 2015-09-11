require 'thor'

module OpStack
  class Commands
    class Env < Thor
      desc "export <environment>", "Load The OpStack Environment"
      def export(environment)
        data = OpStack::Environment::Chef.new.export(environment)
        if data
          OpStack::Exporter.new.run(OpStack.config[:export_prefix],data)
        else
          raise Thor::Error, "Could not export Environment"
        end
      end

      desc "import <environment> <file>", "Import An Environment From A JSON file"
      def import(environment, file)
        if OpStack::Environment::Chef.new.import(environment, file)
          say("#{environment} Imported.")
        else
          raise Thor::Error, "Could not import #{environment} from #{file}"
        end
      end

    end
  end
end