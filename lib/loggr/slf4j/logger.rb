require 'loggr/severity'

module Loggr
  module SLF4J
    
    # A logger which is backed by SLF4J, thus only useable in a JRuby environment.
    #
    class Logger
      
      # Get severities
      include Loggr::Severity
      
      # Basically has *no* impact, because is handled by SLF4J
      attr_accessor :level
      
      # Just to ensure compatiability with AS::BufferedLogger
      attr_reader :auto_flushing, :flush, :close
      
      # Access raw SLF4J logger & marker instances
      attr_reader :java_logger, :java_marker
      
      # Create a new Logger instance for the given name
      #
      def initialize(name, options = {})
        marker = options[:marker].to_s
        marker = 'APP' if marker.length == 0
        
        @java_logger = Java::OrgSlf4j::LoggerFactory.getLogger(name.to_s)
        @java_marker = Java::OrgSlf4j::MarkerFactory.getMarker(marker)
        
        # seriously, this is handled by slf4j and pretty dynamic
        @level = Logger::UNKNOWN
        @auto_flushing = true
      end
      
      # Create the logger methods via meta programming, sweet.
      %w{trace debug info warn error}.each do |severity|
        class_eval <<-EOT, __FILE__, __LINE__ + 1
          def #{severity}(message = nil, progname = nil, &block)                              # def debug(message = nil, progname = nil, &block)
            if java_logger.is_#{severity}_enabled(java_marker)                                #   if java_logger.is_debug_enabled(java_marker)
              java_logger.#{severity}(java_marker, build_message(message, progname, &block))  #     java_logger.debug(java_marker, build_message(message, progname, &block))
            end                                                                               #   end
          end                                                                                 # end
          
          def #{severity}?                                                                    # def debug?
            !!java_logger.is_#{severity}_enabled(java_marker)                                 #   !!java_logger.is_debug_enabled(java_marker)
          end                                                                                 # end
        EOT
      end

      # Add support for fatal, just alias to error
      alias_method :fatal, :error
      alias_method :fatal?, :error?
      
      protected
        
        # Construct the message, note that progname will be ignored, maybe set as
        # MDC?
        def build_message(message = nil, progname = nil, &block)
          message = yield if message.nil? && block_given?
          message.to_s.gsub(/$\s*^/, '')
        end      
    end
  end
end