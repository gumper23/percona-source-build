### Commands
```
# Remove everything
docker system prune -af

# Build image
docker build -t percona-server-8.0.31-23 --no-cache .

# Run container
docker run --rm -v $(pwd):/psp -it percona-server-8.0.31-23 bash

# Build Percona Server
cd /psp
./build.sh 
```
