# Container image that runs your code
FROM docker.cloudsmith.io/cloudsmith/actions-images/python:3.8-slim

# Copies your code file from your action repository to the filesystem path `/` of the container
COPY entrypoint.sh /entrypoint.sh

# Code file to execute when the docker container starts up (`entrypoint.sh`)
ENTRYPOINT ["/entrypoint.sh"]
