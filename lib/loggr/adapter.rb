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
    autoload :Abstract, 'loggr/adapter/abstract'
    
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
    # FIXME: set default backend based on environment, i.e. Rails
    def adapter
      @adapter ||= Loggr::Adapter::Base
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
      self.adapter.logger(name, options).tap do |logger|
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
      # Try
      #
      def get_adapter(adp)
      
      end
  end
end