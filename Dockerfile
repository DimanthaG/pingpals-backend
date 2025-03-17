FROM eclipse-temurin:17-jdk AS build
WORKDIR /workspace/app

# Copy gradle configuration
COPY gradle gradle
COPY gradlew .
COPY settings.gradle .
COPY build.gradle .

# Download dependencies
RUN chmod +x ./gradlew
RUN ./gradlew dependencies

# Copy the source code
COPY src src

# Build the application
RUN ./gradlew clean bootJar
RUN mkdir -p build/dependency && (cd build/dependency; jar -xf ../libs/*.jar)

# Final stage: only use the JRE and the built JAR
FROM eclipse-temurin:17-jre-alpine
ARG DEPENDENCY=/workspace/app/build/dependency

# Create directory for the app
WORKDIR /app

# Copy the dependency application layer by layer
COPY --from=build ${DEPENDENCY}/BOOT-INF/lib /app/lib
COPY --from=build ${DEPENDENCY}/META-INF /app/META-INF
COPY --from=build ${DEPENDENCY}/BOOT-INF/classes /app

# Expose the port the app runs on
ENV PORT=8080
EXPOSE ${PORT}

# Run the application
ENTRYPOINT ["java", "-cp", ".:lib/*", "com.pingpals.pingpals.PingpalsApplication"]
