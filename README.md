# gitlab-php7-composer

## Steps to update image on docker hub

To push a new version x.y.z of this image to docker hub, run the following commands from within the repository root directory:

```
docker build -t kigaroo/gitlab-php7-composer-yarn:x.y.z .
docker push kigaroo/gitlab-php7-composer-yarn:x.y.z
```

(replace x.y.z with the actual version number)
