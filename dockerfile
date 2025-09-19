# 1️ Build stage - Maven container
FROM maven:3.9.4-eclipse-temurin-17 AS builder

WORKDIR /app
# git clone benchmark repo
RUN git clone https://github.com/OWASP-Benchmark/BenchmarkJava.git .

# Build
RUN mvn clean package -DskipTests

# 2️ Final stage - Tomcat container
FROM tomcat:9.0

# WAR file -> Tomcat webapps 
COPY --from=builder /app/target/benchmark.war /usr/local/tomcat/webapps/benchmark.war

# Download HSQLDB jar & Add to Tomcat lib
RUN curl -L -o /usr/local/tomcat/lib/hsqldb.jar \
    https://repo1.maven.org/maven2/org/hsqldb/hsqldb/2.5.2/hsqldb-2.5.2.jar

# context.xml -> conf
COPY context.xml /usr/local/tomcat/conf/context.xml

# Run Tomcat
CMD ["catalina.sh", "run"]
