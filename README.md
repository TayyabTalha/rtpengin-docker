# rtpengin-docker
rtp-engine in docker

## Build  
Clone Repo `git clone https://github.com/TayyabTalha/rtpengin-docker.git`  
move in clone repo `cd rtpengin-docker`  
Build docker image `docker build --tag tayyabtalha/rtpengine:latest .` 

## RUN  
Remove old docker instance `docker rm rtpengine`   
Run New Instance `docker run --network host --privileged --name rtpengine -itd tayyabtalha/rtpengine:latest` 

## Contact: mtayyabtalha@gmail.com
