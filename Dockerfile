FROM openjdk:8-jre-alpine
WORKDIR /app
COPY target/cicd-java-demo-1.0.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java","-jar","app.jar"]
