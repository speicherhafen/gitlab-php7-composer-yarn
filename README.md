# speicherhafen/docker-ci

## Steps to update image on docker hub

To push a new version x.y.z of this image to docker hub, run the following commands from within the repository root directory:

```
IMAGE_TAG=x.y.z make build 
IMAGE_TAG=x.y.z make push 

or

IMAGE_TAG=x.y.z make release 

tag version in git

IMAGE_TAG=x.y.z make git-tag
IMAGE_TAG=x.y.z make push git-tag
```

(replace x.y.z with the actual version number)
