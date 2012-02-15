require 'loggr/adapter'

# This is basically a factory facade to create new Logger instances
# which behave all like standard Ruby Stdlib Loggers.
#
class LoggerFactory
  # Ensure we get all those factory methods directly here
  extend Loggr::Adapter
end
