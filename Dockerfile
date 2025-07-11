# Use base image
FROM tomcat:9.0

# Remove default webapps
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy WAR to webapps
COPY target/SmartBusTracker.war /usr/local/tomcat/webapps/ROOT.war

# Expose port
EXPOSE 8080

# Start Tomcat
CMD ["catalina.sh", "run"]
