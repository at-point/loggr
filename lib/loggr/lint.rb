require 'tempfile'

module Loggr
  module Lint

    # == Adapter and Logger Lint Tests
    #
    # You can test whether an object provides a compliant adapter and logger
    # by including <tt>Logger::Lint::Tests</tt>
    # in your tests.
    #
    # Ensure you set the instance variable <tt>@adapter</tt> to the adapter to lint.
    #
    module Tests

      # Verifies `adapter#logger`, it checks that:
      #
      # - the factory method named #logger exists
      # - that it accepts two arguments, name and options hash
      # - the returned instnace responds to debug, info, warn, error and fatal
      # - responds to tagged and mapped
      #
      def test_adapter_logger
        assert adapter.respond_to?(:logger), "The adapter should respond to #logger"
        assert adapter.method('logger').arity == -2, "The adapter should accept two parameters for #logger, name and options hash"

        @tempfile = Tempfile.new('lint')
        logger = adapter.logger('lint', :to => @tempfile.path)
        %w{debug info warn error fatal}.each do |level|
          assert logger.respond_to?(level), "The logger should respond to ##{level}"
          #assert logger.respond_to?("#{level}?"), "The logger should respond to ##{level}?"
        end

        assert logger.respond_to?(:tagged), "The logger should respond to #tagged"
        assert logger.respond_to?(:mapped), "The logger should respond to #mapped"
      ensure
        @tempfile.unlink if @tempfile
      end

      # Verifies `adapter#mdc`, it checks that:
      #
      # - the factory method named #mdc exists
      # - it accepts no arguments
      # - the returned mdc responds to []=, [], delete, clear and to_hash
      #
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

        # Access the adapter, must be defined <tt>@adapter</tt> in the
        # `setup` method.
        def adapter
          assert !!@adapter, "An adapter must be defined"
          @adapter
        end
    end
  end
end