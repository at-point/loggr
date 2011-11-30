require 'loggr/adapter/abstract'
require 'loggr/support/annotations'

module Loggr
  module Adapter

    # Silences all logging operations, nothing is written at all.
    #
    class NOPAdapter < AbstractAdapter

      class NOPLogger
        # Has no impact anyway :)
        attr_accessor :level

        # Just to ensure compatiability with AS::BufferedLogger
        attr_reader :auto_flushing, :flush, :close

        # Support fuer Annotations wie `tagged` und `mapped`.
        include Loggr::Support::Annotations::NOPSupport

        # Yields empty implementations for all severities
        %w{trace debug info warn error fatal}.each do |severity|
          class_eval <<-EOT, __FILE__, __LINE__ + 1
            def #{severity}(*args, &block)   # def debug(*args, &block)
            end                              # end

            def #{severity}?                 # def debug?
              false                          #   false
            end                              # end
          EOT
        end
      end

      # Get single NOPLogger instance
      def logger(name, options = {})
        @logger ||= NOPLogger.new
      end
    end

    # THE instance
    NOP = NOPAdapter.new
  end
end