FROM registry.cn-hangzhou.aliyuncs.com/acs/maven:3-jdk-8 AS build

COPY pom.xml /usr/src/app/pom.xml
WORKDIR /usr/src/app
RUN mvn dependency:go-offline

COPY src /usr/src/app/src
# use -o to force mvn work offline
RUN mvn -f /usr/src/app/pom.xml -o clean package -DskipTests

FROM openjdk:8-jre
LABEL PROJECT=TN
ENV JAR my-app-1.0-SNAPSHOT.jar
ENV ServerPort 8080
EXPOSE $ServerPort
# COPY target/$JAR /app/
COPY --from=build /usr/src/app/target//$JAR /app/
WORKDIR /app
CMD java -jar /app/$JAR
