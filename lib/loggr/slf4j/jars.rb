module Loggr
  module SLF4J
    
    # Simple access to both SLF4J and Logback implementations, for testing
    # and/or warbler integration.
    #
    module Jars
      
      # Base dir, where the jar files reside, this is "lib/" ergo "lib/loggr/slf4j/jars.rb/../../../"
      SLF4J_LIB_PATH = File.expand_path(File.dirname(File.dirname(File.dirname(__FILE__))))
   
    
      # Path to SLF4J API
      def slf4j_api_jar_path
        @api_jar_path ||= Dir[File.join(SLF4J_LIB_PATH, 'slf4j-api-*.jar')].first
      end
      module_function :slf4j_api_jar_path
  
      # Logback Core JAR
      def logback_core_jar_path
        @logback_core_jar_path ||= Dir[File.join(SLF4J_LIB_PATH, 'logback-core-*.jar')].first
      end
      module_function :logback_core_jar_path
  
      # Logback Classic JAR
      def logback_jar_path
        @logback_jar_path ||= Dir[File.join(SLF4J_LIB_PATH, 'logback-classic-*.jar')].first
      end
      module_function :logback_jar_path
      
      # Require all JARs, if `all` is set to `false`, then only
      # the SLF4J API jar is loaded.
      def require_slf4j_jars!(all = true)
        require self.slf4j_api_jar_path
        if all
          require self.logback_core_jar_path
          require self.logback_jar_path
        end
      end
      module_function :require_slf4j_jars!
      
    end
  end
end