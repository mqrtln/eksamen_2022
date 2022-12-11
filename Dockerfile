FROM maven:3.6.3-jdk-11 as build
WORKDIR /target
COPY . .
RUN mvn --no-transfer-progress package --file pom.xml


FROM adoptopenjdk/openjdk11
COPY --from=build target/onlinestore-0.0.1-SNAPSHOT.jar /target/application.jar
ENTRYPOINT ["java","-jar","/target/application.jar"]