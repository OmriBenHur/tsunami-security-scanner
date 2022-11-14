FROM ubuntu:jammy-20221101
WORKDIR /scanner
COPY ./tsunami .
RUN ["chmod", "+x", "commands.sh"]
RUN ["bash", "-c", "./commands.sh"]
ENTRYPOINT ["/bin/bash"]