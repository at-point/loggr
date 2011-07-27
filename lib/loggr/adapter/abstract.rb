module Loggr
  module Adapter

    # A basically abstract base class for logger backend
    # implementations, provides a default implementation for MDC (hash & thread local based).
    #
    # Ensure to implement `#logger`.
    #
    class AbstractAdapter

      # Implement which creates a new instance of a logger.
      def logger(name, options = {})
        raise "#{self.class.name}#logger is declared `abstract': implement #logger method"
      end

      # Use a simple thread local hash as fake MDC, because it's
      # not supported by the logger anyway - but it should be available
      # for consistency and usage.
      def mdc
        mdc_key = "#{self.class.name}.mdc"
        Thread.current[mdc_key] ||= Hash.new
      end
    end
  end
end