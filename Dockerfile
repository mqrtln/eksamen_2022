FROM maven:3.6.3-jdk-11 as build
COPY . /app
WORKDIR /app
RUN mvn --no-transfer-progress -B package -DskipTests --file pom.xml


FROM adoptopenjdk/openjdk11
WORKDIR /app
COPY target/onlinestore-0.0.1-SNAPSHOT.jar /app/application.jar
ENTRYPOINT ["java","-jar","/app/application.jar"]