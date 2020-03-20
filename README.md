# rtpengin-docker
rtp-engine in docker

## Build
`
git clone https://github.com/TayyabTalha/rtpengin-docker.git
cd rtpengin-docker
docker build --tag tayyabtalha/rtpengine:latest .
`

## RUN
`
# Remove if already created
docker rm rtpengine 
# Run RTP Engine
docker run --network host --privileged --name rtpengine -itd tayyabtalha/rtpengine:latest
`

## Contact: mtayyabtalha@gmail.com
