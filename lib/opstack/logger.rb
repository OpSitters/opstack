require 'logger'
require 'ansi/code'

module OpStack
  module Logger
    # Formatter based on itamae by ryota.arai@gmail.com - lib/itamae/logger.rb
    class Formatter
      attr_accessor :colored

      def call(severity, datetime, progname, msg)
        log = "%s : %s\n" % ["%5s" % severity, msg2str(msg)]
        if colored
          colorize(log, severity)
        else
          log
        end
      end

      def color(code)
        prev_color = @color
        @color = code
        yield
      ensure
        @color = prev_color
      end

      private

      def msg2str(msg)
        case msg
        when ::String
          msg
        when ::Exception
          "#{ msg.message } (#{ msg.class })\n" <<
          (msg.backtrace || []).join("\n")
        else
          msg.inspect
        end
      end

      def colorize(str, severity)
        if @color
          color_code = @color
        else
          color_code = case severity
                       when "INFO"
                         :clear
                       when "WARN"
                         :magenta
                       when "ERROR"
                         :red
                       else
                         :clear
                       end
        end
        ANSI.public_send(color_code) { str }
      end
    end
  end

  @logger = ::Logger.new($stderr).tap do |l|
    l.formatter = OpStack::Logger::Formatter.new
  end

  class << self
    def logger
      @logger
    end

    def logger=(l)
      @logger = l.extend(OpStack::Logger::Helper)
    end
  end
end
