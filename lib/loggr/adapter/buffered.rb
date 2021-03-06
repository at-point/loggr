require 'loggr/adapter/base'
require 'loggr/support/annotations'
require 'active_support/buffered_logger'

module Loggr
  module Adapter

    # Backend for `ActiveSupport::BufferedLogger`.
    #
    class BufferedAdapter < BaseAdapter

      protected
        # Creates a new `AS::BufferedLogger` instance, note that BufferedLogger has
        # no support for setting a default progname, so `name` is basically ignored.
        #
        def build_new_logger(name, options = {})
          logger = ActiveSupport::BufferedLogger.new(options[:to] || "#{name.to_s.gsub(/[\s\/]+/, '_')}.log").tap do |logger|
            logger.level = options[:level] || ActiveSupport::BufferedLogger::INFO
          end
          Loggr::Support::Annotations.enhance(logger)
        end
    end

    # THE instance
    Buffered = BufferedAdapter.new
  end
end