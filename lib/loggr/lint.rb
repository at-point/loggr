require 'tempfile'

module Loggr
  module Lint
    
    # == Adapter and Logger Lint Tests
    #
    # You can test whether an object provides a compliant adapter and logger
    # by including <tt>Logger::Lint::Tests</tt>
    # in your tests.
    #
    # Ensure you set the instance variable <tt>@adapter</tt> to your adapter.
    #
    module Tests
      def test_adapter_logger
        assert adapter.respond_to?(:logger), "The adapter should respond to #logger"
        assert adapter.method('logger').arity == -2, "The adapter should accept two parameters for #logger, name and options hash"

        @tempfile = Tempfile.new('lint')
        logger = adapter.logger('lint', :to => @tempfile.path)
        %w{debug info warn error fatal}.each do |level|
          assert logger.respond_to?(level), "The logger should respond to ##{level}"
          assert logger.respond_to?("#{level}?"), "The logger should respond to ##{level}?"
        end
      ensure
        @tempfile.unlink if @tempfile
      end
      
      def test_adapter_mdc
        assert adapter.respond_to?(:mdc), "The adapter should respond to #mdc"
        assert adapter.method('mdc').arity == 0, "The adapter should accept no parameters for #mdc"
        
        mdc = adapter.mdc
        assert mdc.respond_to?(:[]=), "The mdc should respond to #[]="
        assert mdc.respond_to?(:[]),  "The mdc should respond to #[]"
        assert mdc.respond_to?(:delete),  "The mdc should respond to #delete"
        assert mdc.respond_to?(:clear),   "The mdc should respond to #clear"
        assert mdc.respond_to?(:to_hash), "The mdc should respond to #to_hash"        
      end
            
      protected
      
        # Access the adapter, defined by <tt>@adapter</tt>.
        def adapter
          assert !!@adapter, "An adapter must be defined"
          @adapter
        end
    end
  end
end