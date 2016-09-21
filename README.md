## :warning: UNMAINTANED

**This project is no longer actively maintained.**

Loggr
=====

Loggr provides a factory for creating logger instances. It:

- Provides a wrapper for SLF4J (on JRuby)
- Has adapters for Stdlib Logger and ActiveSupport::BufferedLogger
- Supports Rails, including the new `tagged` method
- Handles using a Mapped Diagnostic Context (MDC)

**So, why should I use a logger factory instead of just `Logger.new('out.log')`
or `Rails.logger`?** Deploying the same application to different environments,
with different logging requirements, might make such a step necessary. Or when
trying to take advante of SLF4J-only features like the MDC or markers.

Information
-----------

**Bug Reports** No software is without bugs, if you discover a problem please report the issue.

https://github.com/at-point/loggr/issues

**Documentation** The latest RDocs are available on rubydoc.info.

http://rubydoc.info/github/at-point/loggr/master/frames

**Gem** The latest stable gem is always on rubygems.org.

http://rubygems.org/gems/loggr

Installation
------------

Like any gem, just add it to the Gemfile:

    # stable version
    gem 'loggr', '~> 1.1.0'

    # latest development version
    gem 'loggr', :git => 'git://github.com/at-point/loggr.git'

Getting started
===============

Guides through creating some sample Logger instances and integration with Rails, if interested
in using the SLF4J Logger directly (without the factory), skip to _The SLF4J Wrapper_.

An example, application runs in development on MRI and production in a Jetty container
(Java/JRuby), lets assume you want to log there SQL using a logger named `jruby.rails.ActiveRecord`.

    # config/initializers/logging.rb:
    LoggerFactory.adapter = Rails.env.production? ? :slf4j : :rails
    ActiveRecord::Base.logger = LoggerFactory.logger 'jruby.rails.ActiveRecord'

Once an adapter has been specified new logger instances can be easily created using:

    def logger
      @logger ||= LoggerFactory.logger 'my.app.SomeClass', :marker => "WORKER"
    end

The adapter then handles creating new logger instances and uses features like the ability
to set markers (if supported), or setting a logger name. Based on the adapter a new logger
will be returned with all things defined like the marker, or a custom logger name - if the
adapter supports it, else it just tries to return a logger which has an API compatible with
those found by Stdlibs Logger.

The LoggerFactory
------------------

Yap, is responsible for creating new loggers, a logger factory has an adapter, the adapter
defines how logger instances are really created.

### Creating new loggers

    LoggerFactory.logger 'app'                      # create a logger with named app
    LoggerFactory.logger 'app', :to => 'debug.out'  # write to debug.out
    LoggerFactory.logger 'app', :to => $stderr      # write to stderr

**Note:** not all adapters support all options, so some adapters might just ignore certain
options, but this is intended :)

### Bundled Adapters

**LoggerFactory.adapter = :base**

The base adapter creates ruby stdlib `Logger` instances. Supported options for
`LoggerFactory.logger(name, options = {})` are:

- `:to`, String or IO, where to log should be written to (default: `"#{name}.log"`)
- `:level`, Fixnum, one of `Logger::Severity`, the minimum severity to log (default: `Logger::Severity::INFO`)

**LoggerFactory.adapter = :buffered**

Creates `ActiveSupport::BufferedLogger` instances and supports the same options
as the `:base` adapter.

**LoggerFactory.adapter = :rails**

This adapter alwasy returns the `Rails.logger`, which is very useful e.g. in development
environments or testing, where we just care that it's somewhere in our `logs/development.log`.
*Note:* Rails is automatically detected and the rails adapter is the default adapter when
`::Rails` is present - else the base adapter is the default.

**LoggerFactory.adapter = :slf4j**

SLF4J only works with JRuby (because it's Java) and you are responsible for a) having an
SLF4J implementation on the classpath and it's configuration. Furthermore slf4j supports
these options for `LoggerFactory.logger(name, options = {})`:

- `:marker`, String, additional marker logged with each statement (default: `nil`)

### Using the Mapped Diagnostic Context (MDC)

Some loggers provide a MDC (or mapped diagnostic context) or a similar feature like
ActiveSupport 3.2s `TaggedLogging#tagged` which can be used to annotate log outputs with
additional bits of information. At the moment only SLF4J and ActiveSupport 3.2 can make
use of this. Though, to provide a clean and consistent API all adapters _must_ provide
access to an MDC and each logger _must_ respond to both `tagged` and `mapped`, so these
features can be used in code no matter the adapter.

A sample use case:

    # app/controllers/application_controller.rb
    class ApplicationController < ActionController::Base
      around_filter :push_ip_to_mdc
      def logger; @logger ||= LoggerFactory.logger('sample') end

      private
        def push_ip_to_mdc
          logger.mapped(:ip => request.ip) do
            yield
          end
        end
    end

When using SLF4J all statements would now be annotated with the IP from where the request
was made from, when using Rails 3.2 it would use it's support for `tagged` and add a tag
named `ip=....`.

The SLF4J Wrapper
=================

Apart from the logger factory, this gem provides a ruby wrapper for logging using SLF4J and
taking advantage of:

- Same API as exposed by Stdlib Logger, AS::BufferedLogger and AS::TaggedLogging
- SLF4J markers
- The Mapped Diagnostic Context (MDC)
- Access to SLF4J & Logback implementation JARs

The Logger
----------

Creating a new logger is as simple as creating instances of `Loggr::SLF4J::Logger`:

    # logger named "my.package.App"
    @logger = Loggr::SLF4J::Logger.new 'my.package.App'

    # logger named "some.sample.Application" => classes are converted to java notation
    @logger = Loggr::SLF4J::Logger.new Some::Sample::Application

    # logger with a default marker named "APP"
    @logger = Loggr::SLF4J::Logger.new 'my.package.App', :marker => 'APP'

Logging events is like using Stdlib Logger:

    # log with level INFO
    @logger.info "some info message"

    # log with level DEBUG, if enabled
    @logger.debug "verbose information" if @logger.debug?

    # log with level DEBUG and marker "QUEUE" (masking as progname)
    @logger.debug "do something", "QUEUE"

The MDC
-------

A wrapper hash for SLF4Js Mapped Diagnostic Context is available using `Loggr::SLF4J::MDC`
like a hash:

    begin
      Loggr::SLF4J::MDC[:user] = username
      do_some_stuff
    ensure
      Loggr::SLF4J::MDC.delete(:user)
    end

It's a good practice to wrap MDC set/get into begin/ensure blocks to ensure the value
is cleared afterwards, even in case of errors. The user is responsible for getting rid
of these values. To just clear all values use `Loggr::SLF4J::MDC.clear`

Tagging and mapping
-------------------

As an alternative to using the MDC directly, each logger exposes a method which is more
ruby-like than setting the MDC and having to handle the `ensure` all by itself.

    logger.mapped(:user => username) do
      do_some_stuff
    end

This ensures that the key is cleared at the end, these calls can also be easily nested.
Starting with ActiveSupport 3.2 there's support for `TaggedLogging`, SLF4J mimics this
behaviour by using the mapped diagnostic context:

    logger.tagged("some", "values") do
      do_some_stuff
    end

Within the block the MDC has been assigned `some, values` to the key `:tags`. Nested values
are just appended to this key.

Extending & Contributing
========================

Of course any custom adapters (e.g. for log4r or the logging gem) are greatly appreciated.
To write a custom adapter just do something like:

    class MyModule::MyCustomAdapter < Loggr::Adpater::AbstractAdapter
      def logger(name, options = {})
        # build logger instances and return it
      end
    end

    # use custom adapter
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

Contribute
----------

1. Fork this project and hack away
2. Ensure that the changes are well tested
3. Send pull request

License & Copyright
-------------------

Loggr is licensed under the MIT License, (c) 2011 by at-point ag.
