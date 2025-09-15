# Bootstrap

In this directory you will find files needed to setup the environment for the upcoming exercises.

## Requirements
- Docker > 28.3
- Basic shell scripting knowledge

## Steps
1. Build the docker image: `docker build . -t nix` 
2. Run newely created image: `docker run -it nix@latest`

At this point you should have access to the shell in the NixOS Docker container!
