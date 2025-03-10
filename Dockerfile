FROM openjdk:11-jre-slim

# Set the working directory
WORKDIR /app

# Copy the built jar from the build directory into the image
COPY build/libs/pingpals-0.0.1-SNAPSHOT.jar app.jar

# Expose the port provided by Render at runtime
EXPOSE 8080

# Start the application using the dynamic port provided by Render
ENTRYPOINT ["sh", "-c", "java -Dserver.port=$PORT -jar app.jar"]
