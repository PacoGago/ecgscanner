FROM maven:3.6.3-openjdk-14-slim AS build 
COPY src /home/app/src
copy pom.xml /home/app
RUN mvn -f /home/app/pom.xml clean package

FROM openjdk:8-alpine
COPY --from=build "home/app/target/ECGScannerAPIRest-0.0.1-SNAPSHOT.jar" "app.jar"
EXPOSE 8080
ENTRYPOINT ["java","-jar","app.jar"]