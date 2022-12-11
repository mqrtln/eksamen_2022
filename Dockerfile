FROM maven:3.6.3-jdk-11 as build
WORKDIR /app
COPY pom.xml .
RUN mvn package


FROM adoptopenjdk/openjdk11
WORKDIR /app
COPY --from=build target/onlinestore-0.0.1-SNAPSHOT.jar /app/application.jar
ENTRYPOINT ["java","-jar","/app/application.jar"]