require 'loggr/severity'
require 'loggr/slf4j/mdc'

module Loggr
  module SLF4J

    # Simple marker factory which uses `org.slf4j.MarkerFactory`, but
    # caches the result in a local ruby hash, by name.
    class MarkerFactory

      # Get marker for any non-empty string.
      def self.[](name)
        name = name.to_s.strip
        return nil if name.length == 0
        @markers ||= {}
        @markers[name] ||= Java::OrgSlf4j::MarkerFactory.getMarker(name)
      end
    end

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
      attr_reader :java_logger, :java_marker, :java_mdc

      # Create a new Logger instance for the given name
      #
      def initialize(name, options = {})
        name = self.class.in_java_notation(name)
        @java_logger = Java::OrgSlf4j::LoggerFactory.getLogger(name.to_s)
        @java_marker = MarkerFactory[options[:marker]]
        @java_mdc = options[:mdc] || Loggr::SLF4J::MDC

        # seriously, this is handled by slf4j and pretty dynamic
        @level = Logger::UNKNOWN
        @auto_flushing = true
      end

      # Create the logger methods via meta programming, sweet.
      %w{trace debug info warn error}.each do |severity|
        class_eval <<-EOT, __FILE__, __LINE__ + 1
          def #{severity}(message = nil, progname = nil, &block)                         # def debug(message = nil, progname = nil, &block)
            marker = (progname ? MarkerFactory[progname] : nil) || java_marker           #   marker = (progname ? MarkerFactory[progname] : nil) || java_marker
            if java_logger.is_#{severity}_enabled(marker)                                #   if java_logger.is_debug_enabled(marker)
              java_logger.#{severity}(marker, build_message(message, progname, &block))  #     java_logger.debug(marker, build_message(message, progname, &block))
            end                                                                          #   end
          end                                                                            # end

          def #{severity}?                                                               # def debug?
            !!java_logger.is_#{severity}_enabled(java_marker)                            #   !!java_logger.is_debug_enabled(java_marker)
          end                                                                            # end
        EOT
      end

      # Add support for fatal, just alias to error
      alias_method :fatal, :error
      alias_method :fatal?, :error?

      # Uses the mapped diagnostic context to add tags, like
      # ActiveSupport 3.2's TaggedLogger.
      #
      def tagged(*new_tags)
        old_tags = java_mdc[:tags].to_s
        java_mdc[:tags] = (old_tags.split(', ') + new_tags.flatten).join(', ')
        yield
      ensure
        java_mdc[:tags] = old_tags.length == 0 ? nil : old_tags
      end

      # A more describtive alternative to tagged is mapped, which just makes
      # use of the MDC directly, basically.
      def mapped(hash = {})
        old_keys = hash.keys.inject({}) { |hsh,k| hsh[k] = java_mdc[k]; hsh }
        hash.each { |key, value| java_mdc[key] = value }
        yield
      ensure
        old_keys.each { |key, value| java_mdc[key] = value }
      end

      # If a class, module or object is used converts `Foo::Bar::SomeThing` to
      # java notation: `foo.bar.SomeThing`. Symbols and Strings are left as is!
      #
      def self.in_java_notation(name)
        return name.to_s if name.respond_to?(:to_str) || name.is_a?(Symbol)
        name = name.is_a?(Module) ? name.name.to_s : name.class.name.to_s
        parts = name.split('::')
        last  = parts.pop
        parts.map { |p| p.downcase }.push(last).join('.')
      end

      protected

      # Construct the message, note that progname will be ignored, maybe set as
      # MDC?
      #
      # Removes leading newlines.
      def build_message(message = nil, progname = nil, &block)
        message = yield if message.nil? && block_given?
        message.to_s.sub(/^\n+/, '')
      end
    end
  end
end