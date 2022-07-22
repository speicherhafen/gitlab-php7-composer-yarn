IMAGE_TAG ?= latest
RELEASE_IMAGE := speicherhafen/ci:$(IMAGE_TAG)

.PHONY: build
build:
	docker build --pull -f Dockerfile -t $(RELEASE_IMAGE) .

.PHONY: push
push:
	docker push $(RELEASE_IMAGE)

.PHONY: run
run:
	docker run --rm -it --entrypoint bash $(RELEASE_IMAGE)

.PHONY: git-tag
git-tag:
	git tag $(IMAGE_TAG)

.PHONY: push-git-tag
push-git-tag:
	git push --tags

.PHONY: release
release: build push
