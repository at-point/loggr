module Loggr
  
  # The factory is responsible for getting Logger instances from
  # the adapters.
  #
  # It delegates both the `logger` and `mdc` calls to the current
  # adpater.
  #
  # The adpater can be changed by setting `adpater = ...`:
  #
  #    Loggr.adapter = Loggr::Adapter::SLF4J
  #
  # @see #logger, #mdc  
  module Adapter
    
    # An abstract base class, which provides a simple MDC implementation
    autoload :AbstractAdapter, 'loggr/adapter/abstract'
    
    # Adapter for Ruby Stdlib Logger
    autoload :Base,     'loggr/adapter/base'
    
    # Adapter for ActiveSupport::BufferedLogger, requires AS
    autoload :Buffered, 'loggr/adapter/buffered'
        
    # Adapter which uses Rails.logger
    autoload :Rails,    'loggr/adapter/rails'
    
    # Adpater for SLF4J
    autoload :SLF4J,    'loggr/adapter/slf4j'
        
    # Get the backend, if no backend is defined uses the default backend.
    #
    def adapter
      @adapter ||= Object.const_defined?(:Rails) ? Loggr::Adapter::Rails : Loggr::Adapter::Base
    end
    
    # Set a new adapter, either as string, class or whatever :)
    #
    def adapter=(new_adapter)
      @adapter = get_adapter(new_adapter)
    end
        
    # Get a new logger instance for supplied named logger or class name.
    #
    # All adapters must ensure that they provide the same API for creating
    # new loggers. Each logger has a name, further possible options are:
    #
    # - `:to`, filename or IO, where to write the output to
    # - `:level`, Fixnum, starting log level, @see `Loggr::Severity`
    # - `:marker`, String, name of the category/marker
    #
    # If a adapter does not support setting a specific option, just
    # ignore it :)
    def logger(name, options = {}, &block)
      use_adapter = options.key?(:adapter) ? get_adapter(options.delete(:adapter)) : self.adapter
      use_adapter.logger(name, options).tap do |logger|
        yield(logger) if block_given?
      end
    end
    
    # The Mapped Diagnostic Context is a basically a hash where values
    # can be stored for certain keys, the context must be stored per thread.
    #
    # The most basic MDC implementation is `Thread.local['my_simple_mdc'] ||= Hash.new`.
    #
    # If a adapter provides a native MDC implementation ensure it does expose
    # these methods:
    #
    # - `def []=(key, value)`, set a property in the MDC
    # - `def [](key)`, get a property from the MDC
    # - `def delete(key)`, delete a property in the MDC
    # - `def clear()`, deletes all properties from the MDC
    # - `def to_hash`, access MDC as standard ruby hash (might be clone, though!)
    #
    # Well it should basically behave like a Ruby Hash, eventhough not with all
    # options.
    def mdc
      self.adapter.mdc
    end
    
    protected
    
      # Try to get adapter class from Symbol, String or use Object as-is.
      #
      def get_adapter(adp)
        adp = Loggr::Adapter::SLF4J if adp == :slf4j # okay, this is only because we can't camelize it :)
        
        # Code adapter from ActiveSupport::Inflector#camelize
        # https://github.com/rails/rails/blob/v3.0.9/activesupport/lib/active_support/inflector/methods.rb#L30
        adp = adp.to_s.gsub(/\/(.?)/) { "::#{$1.upcase}" }.gsub(/(?:^|_)(.)/) { $1.upcase } if adp.is_a?(Symbol)
        
        clazz = adp
        
        if adp.respond_to?(:to_str)
          const = begin Loggr::Adapter.const_get(adp.to_s) rescue nil end
          unless const
            # code adapter from ActiveSupport::Inflector#constantize
            # https://github.com/rails/rails/blob/v3.0.9/activesupport/lib/active_support/inflector/methods.rb#L107
            names = adp.to_s.split('::')
            names.shift if names.empty? || names.first.empty?
            
            const = ::Object
            names.each { |n| const = const.const_get(n) }
          end
          clazz = const          
        end
        
        raise "#{clazz}: an adapter must implement #logger and #mdc" unless clazz.respond_to?(:logger) && clazz.respond_to?(:mdc)
        clazz
      end
  end
end