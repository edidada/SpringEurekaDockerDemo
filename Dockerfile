# dockerfile 基础配置
FROM daocloud.io/library/java:8u40-b22
VOLUME /tmp
ARG JAR_FILE
ADD ${JAR_FILE} /app/app.jar
WORKDIR /app/
EXPOSE 8889
ENTRYPOINT ["java","-jar","./app.jar"]