# Bootstrap

In this directory you will find files needed to setup the environment for the upcoming exercises.

## Requirements
- Docker > 28.3
- Basic shell scripting knowledge

## Steps
1. Build the docker image: `docker build . -t nix` 
2. Run the newly created image:

   **For Python & Go exercises:**
   ```bash
   docker run -it nix:latest
   ```

   **For the TypeScript exercises (required):**
   You must expose port **8080** so the webpack dev server is reachable from your host:
   ```bash
   docker run -it -p 8080:8080 nix:latest
   ```
   Without `-p 8080:8080`, the TypeScript workshop page at `http://localhost:8080` will not load.

At this point you should have access to the shell in the NixOS Docker container!

Now head to the README dedicated to the language you choose. Have fun!
