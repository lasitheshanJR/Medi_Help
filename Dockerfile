# Build stage
FROM maven:3.9.6-eclipse-temurin-17 AS build
WORKDIR /app
COPY pom.xml .
COPY src ./src
# Build the application, skipping tests to ensure fast and reliable deployment build
RUN mvn clean package -DskipTests

# Run stage
FROM eclipse-temurin:17-jre-jammy
WORKDIR /app
# Copy the built JAR from the builder stage
COPY --from=build /app/target/mediqueue-0.0.1-SNAPSHOT.jar app.jar

# Allow Railway/Cloud hosts to inject the port
ENV PORT=8082
EXPOSE 8082

# Run the JAR and tell Spring to use the injected PORT variable
ENTRYPOINT ["java", "-Xmx512m", "-jar", "app.jar", "--server.port=${PORT}"]
