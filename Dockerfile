FROM maven:3.9.16-eclipse-temurin-21-alpine AS maven

WORKDIR /app

COPY .mvn/ ./.mvn
COPY mvnw pom.xml ./

RUN mvn dependency:go-offline

COPY src ./src

RUN mvn package -DskipTests

FROM eclipse-temurin:21-jre-alpine

WORKDIR /app

RUN addgroup -S spring && adduser -S spring -G spring

COPY --from=maven /app/target/*.jar ./app.jar

RUN chown -R spring:spring /app

USER spring

EXPOSE 9090
ENTRYPOINT ["java", "-jar", "app.jar"]