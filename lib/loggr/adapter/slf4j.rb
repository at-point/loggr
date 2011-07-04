require 'loggr/slf4j'

module Loggr
  module Adapter
    
    # Provides an adapter for the SLF4J Logger.
    #
    class SLF4JAdapter < BaseAdapter      
      # Use the SLF4J backed real MDC.
      def mdc
        @mdc ||= Loggr::SLF4J::MDC
      end
      
      protected
        # Create a new SLF4JLogger instance.
        def build_new_logger(name, options = {})
          Loggr::SLF4J::Logger.new(name, options)
        end            
    end
    
    # THE instance of it
    SLF4J = SLF4JAdapter.new
  end
end