require 'loggr/adapter/slf4j/logger'
require 'loggr/adapter/slf4j/mdc'

module Loggr
  module Adapter
    
    # 
    #
    class SLF4JAdapter < BaseAdapter      
      # Use the SLF4J backed real MDC.
      def mdc
        @mdc ||= Loggr::Adapter::SLF4JMdc.new
      end
      
      protected
        # Create a new SLF4JLogger instance.
        def build_new_logger(name, options = {})
          Loggr::Adapter::SLF4JLogger.new(name, options)
        end            
    end
    
    # THE instance of it
    SLF4J = SLF4JAdapter.new
  end
end