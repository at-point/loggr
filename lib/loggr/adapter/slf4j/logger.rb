begin
  Java::OrgSlf4j::LoggerFactory
rescue
  require File.join(File.dirname(__FILE__), 'slf4j-api-1.6.1.jar')
end

module Loggr
  module Adapter
    
    # A logger which is backed by SLF4J, thus only useable in a JRuby environment.
    #
    class SLF4JLogger
      
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
        
        # seriously, this is handled by slf4j
        @level = Loggr::UNKNOWN
        @auto_flushing = true
      end
      
      # Create the logger methods via meta programming, sweet.
      %w{trace debug info warn error}.each do |severity|
        class_eval <<-EOT, __FILE__, __LINE__ + 1
          def #{severity}(message = nil, progname = nil, &block)                    # def debug(message = nil, progname = nil, &block)
            if logger.is_#{severity}_enabled(marker)                                #   if logger.is_debug_enabled(marker)
              logger.#{severity}(marker, build_message(message, progname, &block))  #     logger.debug(marker, build_message(message, progname, &block))
            end                                                                     #   end
          end                                                                       # end
          
          def #{severity}?                                                          # def debug?
            !!logger.is_#{severity}_enabled(marker)                                 #   !!logger.is_debug_enabled(marker)
          end                                                                       # end
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