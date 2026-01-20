FROM openjdk:17-jdk-slim

ARG PROFILE=prod
ARG APP_PORT=7080
ARG DB_HOST=localhost
ARG DB_PORT=5432
ARG DB_NAME=billing
ARG DB_USER=postgres
ARG DB_PASSWORD=postgres

ENV SPRING_PROFILES_ACTIVE=${PROFILE}
ENV SERVER_PORT=${APP_PORT}
ENV DB_HOST=${DB_HOST}
ENV DB_PORT=${DB_PORT}
ENV DB_NAME=${DB_NAME}
ENV DB_USER=${DB_USER}
ENV DB_PASSWORD=${DB_PASSWORD}

WORKDIR /app

COPY pom.xml .
COPY src ./src

RUN apt-get update && apt-get install -y maven && \
    mvn package -P${PROFILE} -DskipTests && \
    apt-get remove -y maven && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/*

EXPOSE ${APP_PORT}

CMD ["java", "-jar", "target/billing-0.0.1.jar"]