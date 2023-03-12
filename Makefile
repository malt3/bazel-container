export DOCKER_BUILDKIT=1

.PHONY: container container-push

container:
	docker build -f Containerfile -t ghcr.io/malt3/bazel-container .

container-push:
	docker push ghcr.io/malt3/bazel-container
