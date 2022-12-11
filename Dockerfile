FROM maven:3.6.3-jdk-11 as build
WORKDIR /tmp
COPY . .
RUN mvn --no-transfer-progress package --file pom.xml


FROM adoptopenjdk/openjdk11
WORKDIR /tmp
COPY --from=build target/onlinestore-0.0.1-SNAPSHOT.jar /tmp/application.jar
ENTRYPOINT ["java","-jar","/app/application.jar"]