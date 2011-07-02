require 'loggr/adapter/abstract'
require 'logger'

module Loggr
  module Adapter
    
    # Default backend which is backed Rubys Stdlib Logger.
    #
    #
    class BaseAdapter < AbstractAdapter
      
      # 
      #
      def logger(name, options = {})
        @loggers ||= {}
        @loggers[name] ||= build_new_logger(name, options)
      end
      
      protected
        # Constructs a new logger instance for the supplied options, is called
        # by `#loggers` when no logger with this name already exists - instead of
        # creating a new logger...
        #
        def build_new_logger(name, options = {})
          Logger.new(options[:to] || "#{name.to_s.gsub(/[\s\/]+/, '_')}.log").tap do |logger|
            logger.level = options[:level] || Logger::DEBUG
            logger.progname = name
          end        
        end
    end
    
    # Okay, basically a singleton thus create instance
    Base = BaseAdapter.new
  end
end