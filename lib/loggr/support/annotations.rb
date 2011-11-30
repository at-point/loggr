module Loggr

  module Support

    #
    #
    module Annotations

      # A doing nothing implementation of tagged & mapped,
      # just to ensure the methods exist.
      module NOPSupport
        def tagged(*args); yield if block_given? end
        alias_method :mapped, :tagged
      end

      # Enhances supplied logger with the required features
      # to handle both `tagged` and `mapped` on the logger itself.
      #
      def self.enhance(logger)
        return logger if logger.respond_to?(:tagged) && logger.respond_to?(:mapped)
        return ::ActiveSupport::TaggedLogging.new(logger) if defined?(::ActiveSupport::TaggedLogging)
        logger.send(:extend, NOPSupport)
      end
    end
  end
end

# Try to load AS::TaggedLogging
begin
  require 'active_support/tagged_logging'

  # Enable support for `mapped(:user => "demo")` which falls
  # back to make use of its `tagged` method.
  class ::ActiveSupport::TaggedLogging

    # Uses `tagged` to tag items with the hash of infos.
    def mapped(hash = {}, &block)
      tagged(hash.map { |h,k| "#{h}=#{k}" }, &block)
    end
  end
rescue LoadError; end # uhm, ignore we have other ideas ;)
