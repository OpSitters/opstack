require 'thor'
require 'opstack/logger'
require 'opstack/commands'

module OpStack
  class CLI < Thor
    class_option :log_level, type: :string, aliases: ['-l'], default: 'info'
    class_option :color, type: :boolean, default: true

    def initialize(*args)
      super
      OpStack.logger.level = ::Logger.const_get(options[:log_level].upcase)
      OpStack.logger.formatter.colored = options[:color]
    end

    def self.exit_on_failure?
      true
    end

    desc "env SUBCOMMAND ...ARGS", "environment comands"
    subcommand "env", OpStack::Commands::Env
  end
end