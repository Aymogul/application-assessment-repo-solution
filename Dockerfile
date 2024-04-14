#from base image
FROM openjdk:8

ADD target/spring-petclinic-2.4.2.war spring-petclinic-2.4.2.war 

# open this port for the image
EXPOSE 8080

ENTRYPOINT ["java", "-jar", "spring-petclinic-2.4.2.war"]
