# docker-keycloak

Multiarch docker images for [keycloak/keycloak](https://github.com/keycloak/keycloak)

## Build image

git clone https://github.com/keycloak/keycloak-containers.git
cd keycloak-containers
git co 16.0.0
docker buildx build ./server --platform linux/arm64,linux/amd64 -t cyrilix/keycloak:16.0.0 --push
