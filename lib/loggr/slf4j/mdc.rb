module Loggr
  module SLF4J

    # Wrapper around the SLF4J MDC.
    #
    class MDCWrapper

      # Access the original SLF4J MDC
      attr_accessor :java_mdc

      # Create a new SLF4J MDC with the supplied implementation.
      def initialize(impl = Java::OrgSlf4j::MDC)
        @java_mdc = impl
      end

      # Read a key from the MDC.
      def [](key); java_mdc.get(key.to_s) end

      # Write a value to the MDC.
      def []=(key, value); value.nil? ? java_mdc.remove(key.to_s) : java_mdc.put(key.to_s, value.to_s) end

      # Remove a key from the MDC.
      def delete(key); java_mdc.remove(key.to_s) end

      # Clear all keys from the MDC.
      def clear; java_mdc.clear() end

      # Convert MDC to a real hash.
      def to_hash; java_mdc.getCopyOfContextMap().freeze end
    end

    # An instance is available as MDC :)
    MDC = MDCWrapper.new
  end
end