FROM maven:3.6.3-jdk-11 as build
WORKDIR /app
COPY . .
RUN mvn --no-transfer-progress -DskipTests package --file pom.xml


FROM adoptopenjdk/openjdk11
COPY --from=build /app/target/onlinestore-0.0.1-SNAPSHOT.jar /app/application.jar
ENTRYPOINT ["java","-jar","/app/application.jar"]