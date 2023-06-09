.PHONY:	prepare build deploy clean

PULL_DOCKER_REPO ?= quay.io
PUSH_DOCKER_REPO ?= quay.io
DOCKER_REPO_USER ?= please-set-user-name
DOCKER_REPO_PASS ?= please-set-password

VERSION ?= 7.0.10

prepare:
	#echo ${DOCKER_REPO_PASS} | docker login ${PULL_DOCKER_REPO} -u ${DOCKER_REPO_USER} --password-stdin
	echo ${DOCKER_REPO_PASS} | docker login ${PUSH_DOCKER_REPO} -u ${DOCKER_REPO_USER} --password-stdin

build:
	podman build --network host . \
		-t ${PUSH_DOCKER_REPO}/redis-benchmark:${VERSION} \
		-t ${PUSH_DOCKER_REPO}/redis-benchmark:latest \
		--build-arg REDIS_VERSION=${VERSION} \
		--build-arg DOCKER_REPO=${PULL_DOCKER_REPO}

publish: prepare
	podman push ${PUSH_DOCKER_REPO}/redis-benchmark:${VERSION}
	podman push ${PUSH_DOCKER_REPO}/redis-benchmark:latest

clean:
	docker image rm ${PUSH_DOCKER_REPO}/redis-benchmark:${VERSION}