# mathhub_docker

## Install
It is recommended to get the fully setup up version from docker hub by running  
```docker pull kwarc/mathhub:dev```

## Run
For the web server (will start on localhost:9999)
```docker run -d -p 9999:80 kwarc/mathhub start-mh ```
For internal configuration/access (i.e. bash)
```docker run -t -i kwarc/mathhub:dev /bin/bash```
For developing on the machine directly while server is active (to see results of changes immediately)
```docker run -ti -p 9999:80 kwarc/mathhub start-mhd```

## Manual Setup
Do 
```docker build .``` 
in the top directory. 
Then run the web server (see above) and go to localhost:9999/install.php to finish setup.
Finally, configure as described [here](https://github.com/KWARC/MathHub/blob/master/README.md#mathhub-configuration).
