FROM maven:3.8.7-openjdk-18-slim as base

WORKDIR /app

COPY src src/
COPY pom.xml .

RUN mvn package

HEALTHCHECK --interval=5s --timeout=3s \
  CMD curl -f http://localhost:8080/healthcheck || exit 1

CMD java -jar /app/target/hello-world-0.1.0.jar
