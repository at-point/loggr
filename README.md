Loggr
=====

Loggr provides a factory for creating logger instances. **Why should I use a logger factory
instead of just `Logger.new('out.log')` or `Rails.logger`?** Deploying the same application
to different environments, with different logging requirements, might make such a step
necessary.

The factory has basically been designed to take advantage of features in SLF4J (JRuby only),
yet have a consistent API to work in all environments (non-JRuby, development etc.).

An example, application runs in development on MRI and production in a Jetty container
(Java/JRuby), lets assume you want to log there SQL using a logger named `jruby.rails.ActiveRecord`.

    # config/initializers/logging.rb:
    LoggerFactory.adapter = Rails.env.production? ? :slf4j : :rails
    ActiveRecord::Base.logger = LoggerFactory.logger 'jruby.rails.ActiveRecord'
    
Now, honestly, why not just put it all into the `production.rb` file and keep that logger
factory away? Maybe, the application requires more loggers, for other needs, like a logger
for auditing, or reporting on some background jobs?

There are two ways to solve it:

1. create global loggers per environment and ensure to setup them up correctly, based on
   the current environment, available loggers etc. etc. -> cumbersome
2. or simply use the `LoggerFactory`

Once an adapter has been specified new logger instances can be easily created using:

    def logger
      @logger ||= LoggerFactory.logger 'my.app.SomeClass', :marker => "WORKER"
    end
    
The adapter then handles creating new logger instances and uses features like the ability
to set markers (if supported), or setting a logger name. Based on the adapter a new logger
will be returned with all things defined like the marker, or a custom logger name - if the
adapter supports it, else it just tries to return a logger which has an API compatible with
those found by Stdlibs Logger.

The `LoggerFactory`
-------------------

Yap, is responsible for creating new loggers, a logger factory has an adapter, the adapter
defines how logger instances are really created.

### Creating new loggers

    LoggerFactory.logger 'app'                      # create a logger with named app
    LoggerFactory.logger 'app', :to => 'debug.out'  # write to debug.out
    LoggerFactory.logger 'app', :to => $stderr      # write to stderr
    
**Note:** not all adapters support all options, so some adapters might just ignore certain
options, but this is intended :)

### Chaning Adapters

`LoggerFactory.adapter = :base` - The base adapter creates ruby stdlib `Logger` instances.
Supported options for `LoggerFactory.logger(name, options = {})` are:

- `:to`, String or IO, where to log should be written to (default: `"#{name}.log"`)
- `:level`, Fixnum, one of `Logger::Severity`, the minimum severity to log (default: `Logger::Severity::DEBUG`)

`LoggerFactory.adapter = :buffered` - Creates `ActiveSupport::BufferedLogger` instances and
supports the same options as the `:base` adapter.

`LoggerFactory.adapter = :rails` - This adapter alwasy returns the `Rails.logger`, which is very
useful e.g. in development environments or testing, where we just care that it's somewhere in
our `logs/development.log`.

`LoggerFactory.adapter = :slf4j` - SLF4J only works with JRuby (because it's Java) and you
are responsible for a) having an SLF4J implementation on the classpath and it's configuration.
Furthermore slf4j supports these options for `LoggerFactory.logger(name, options = {})`:

- `:marker`, String, additional marker logged with each statement (default: `APP`)

### Using the Mapped Diagnostic Context (MDC)

Some loggers provide a MDC (or mapped diagnostic context), which can be used to annotate
log outputs with additional bits of information. At the moment only SLF4J really can make
use of this. Though, to provide a clean and consistent API all adapters _must_ provide
access to an MDC, so the MDC can be used in code no matter the adapter, a sample use case
(in Rails):

    # app/controllers/application_controller.rb
    class ApplicationController < ActionController::Base
      before_filter :set_mdc
      
      protected
        def set_mdc
          LoggerFactory.mdc[:ip] = request.ip
        ensure
          LoggerFactory.mdc.delete(:ip)
        end
    end
    
When using SLF4J all statements would now be annotated with the IP who has made the
request.

Custom adapters
---------------

Of course any custom adapters (e.g. for log4r or the logging gem) are greatly
appreciated. To use a custom adapter just do something like:

    class MyModule::MyCustomAdapter < Loggr::Adpater::AbstractAdapter    
      def logger(name, options = {})
        # build logger instances and return it
      end      
    end
    
    # use own adapter
    LoggerFactory.adapter = MyModule::MyCustomAdapter.new
    
Extending from `Loggr::Adapter::AbstractAdapter` provides the adapter with a default
MDC implementation (backed by a hash stored in a thread local).

Similar to ActiveModel there are also Lint tests available to verify if your adapter
and the logger and mdc returned adhere to the API.

    class MyModule::MyCustomAdapterTest < Test::Unit::TestCase
       include Loggr::Lint::Tests
       
       def setup
         # required, so the Lint Tests can pick it up
         @adapter = MyModule::MyCustomAdapter.new
       end
    end
