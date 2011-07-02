module Loggr
  
  # Exactly the same severities as Ruby Stdlib Logger.
  #
  module Severity
    # Okay, trace is new :)
    TRACE = -1
    
    DEBUG = 0
    INFO  = 1
    WARN  = 2
    ERROR = 3
    FATAL = 4
    UNKNOWN = 5
  end
end