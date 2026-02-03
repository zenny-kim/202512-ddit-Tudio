FROM eclipse-temurin:21-jre-alpine

ARG JAR_FILE=target/*.jar

WORKDIR /app

COPY keystore.p12 ./keystore.p12

COPY ${JAR_FILE} app.jar

COPY src/main/webapp /app/webapp

EXPOSE 8060

ENTRYPOINT ["java", "-jar", "app.jar", "--server.tomcat.document-root=/app/webapp", "--server.servlet.context-path=/tudio"]