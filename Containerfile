FROM fedora:37
ARG TARGETOS
ARG TARGETARCH
ARG BAZELISK_VERSION=v1.16.0
ARG BAZELISK_SHA256=168851e70cf5f95c0e215e7f3aaca5132ffc3c8dd8f585a4157b0be2b53cfe32
RUN mkdir -p /usr/local/bin && \
	curl -fsSLo /usr/local/bin/bazelisk \
	"https://github.com/bazelbuild/bazelisk/releases/download/${BAZELISK_VERSION}/bazelisk-${TARGETOS}-${TARGETARCH}" && \
	echo "${BAZELISK_SHA256} /usr/local/bin/bazelisk" | sha256sum -c && \
	chmod +x /usr/local/bin/bazelisk && \
	ln -s /usr/local/bin/bazelisk /usr/local/bin/bazel && \
	dnf install -y \
	git \
	diffutils \
	&& \
	dnf clean all && \
	groupadd --gid 1000 builder && \
	useradd -rm -d /home/builder -s /bin/bash -g root -u 1000 --gid builder builder && \
	mkdir -p /home/builder/.cache && \
	mkdir -p /workspace && \
	chown -R builder:builder /home/builder/.cache /workspace && \
	git config --global --add safe.directory /workspace
USER builder
WORKDIR /workspace
ENTRYPOINT [ "/usr/local/bin/bazel" ]
RUN git config --global --add safe.directory /workspace
