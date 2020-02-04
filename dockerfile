FROM openjdk:8
EXPOSE 8080:8080

COPY start.sh ~/
ENTRYPOINT ["~/start.sh"]
