require 'loggr/adapter/abstract'
require 'loggr/support/annotations'

module Loggr
  module Adapter

    # Always uses the logger defined on `Rails.logger`, CAVEAT ensure to never
    # ever set `Rails.logger` to this backend, i.e.:
    #
    #    # IF YOU DID THIS...
    #    Loggr.adapter = Loggr::Adapter::Rails
    #
    #    MyApp::Application.configure do
    #      # ...NEVER DO THIS !!!
    #      config.logger = Loggr.logger('rails')
    #    end
    #
    # If you are using the rails adapter, ensure that you do not override `config.logger`
    # with an instance of the Rails adapter logger factory. Keep the default logger, or
    # create a new one using:
    #
    #    config.logger = Loggr.logger('rails', :backend => Loggr::Adapter::Buffered)
    #
    class RailsAdapter < AbstractAdapter

      # The rails backend ignores all options as it just returns
      # always returns `Rails.logger` :)
      #
      # Ensures we get some black magic using `tagged` and `mapped`.
      def logger(name, options = {})
        Loggr::Support::Annotations.enhance ::Rails.logger
      end
    end

    # THE Rails backed implementation instance
    Rails = RailsAdapter.new
  end
end