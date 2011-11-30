require 'loggr/adapter/abstract'
require 'loggr/support/annotations'

module Loggr
  module Adapter

    # Default backend which is backed Rubys Stdlib Logger.
    #
    class BaseAdapter < AbstractAdapter

      #
      #
      def logger(name, options = {})
        name = normalize_name(name)
        @loggers ||= {}
        @loggers[name] ||= build_new_logger(name, options)
      end

      protected
        # Constructs a new logger instance for the supplied options, is called
        # by `#loggers` when no logger with this name already exists - instead of
        # creating a new logger...
        #
        def build_new_logger(name, options = {})
          logger = ::Logger.new(options[:to] || "#{name.to_s.gsub(/[:\s\/]+/, '_')}.log").tap do |logger|
            logger.level = options[:level] || Logger::INFO
            logger.progname = name
          end
          Loggr::Support::Annotations.enhance(logger)
        end

        # Because we should also allow using class names, or objects
        # to construct new loggers (like in SLF4J), it makes sense to
        # have a method which normalizes some input, be it a string or
        # whatnot to convert to an appropriate name.
        #
        # Subclasses are of course allowed to override this, of course
        # loggers themself are allowed to tweak that name further - this
        # is basically to enable creating loggers from classes/objects
        # for AS::BufferedLoggers and Stdlib Loggers.
        #
        def normalize_name(name)
          return name.to_str if name.respond_to?(:to_str)
          case name
            when Symbol then name.to_s
            when Module then name.name.to_s
            else name.class.name.to_s
          end
        end
    end

    # Okay, basically a singleton thus create instance
    Base = BaseAdapter.new
  end
end
