FROM openjdk:8-jdk-alpine
RUN apk update && apk upgrade
VOLUME /tmp
EXPOSE 8000
ADD target/*.jar app.jar
ENV JAVA_OPTS=""

#User
RUN addgroup -g 1001 -S webapp && adduser -u 1001 -S -D -g ''  webapp -G webapp \
    && sed -e 's/^wheel:\(.*\)/wheel:\1,webapp/g' -i /etc/group \
     && sed -e 's/# %wheel ALL=(ALL) NOPASSWD: ALL/%wheel ALL=(ALL) NOPASSWD: ALL/g' \
      -i /etc/sudoers

USER webapp    
  
ENTRYPOINT [ "sh", "-c", "java -jar /app.jar" ]