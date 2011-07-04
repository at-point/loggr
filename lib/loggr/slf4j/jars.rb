module Loggr
  module SLF4J
    
    # Base dir, where the jar files reside
    JAR_DIR = File.dirname(File.dirname(File.dirname(__FILE__)))
   
    # SLF4J API JAR
    API_JAR = Dir[File.join(JAR_DIR, 'slf4j-api-*.jar')].first
    
    # Logback Implementation JARs
    LOGBACK_JARS = Dir[File.join(JAR_DIR, 'logback-c*.jar')]
    
    # Both API & Logback implementation JARs
    JARS = [API_JAR] + LOGBACK_JARS
    
    # Require all JARs, if `all` is set to `false`, then only
    # the SLF4J API jar is loaded.
    def self.require_jars!(all = true)
      (all ? JARS : [API_JAR]).each { |jar| require jar }      
    end
  end
end