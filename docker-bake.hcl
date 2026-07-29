variable "UBUNTU_VERSION" {
  default = "24.04"
}

variable "UBUNTU_DIGEST" {
  default = "sha256:4fbb8e6a8395de5a7550b33509421a2bafbc0aab6c06ba2cef9ebffbc7092d90"
}

variable "CODEX_VERSION" {
  default = "0.146.0"
}

variable "CODEX_ARCHIVE_SHA256" {
  default = "3c89125af1d7c98abec8beb551292ef99daca52e204e5852a9139feae2c467e5"
}

variable "GH_VERSION" {
  default = "2.96.0"
}

variable "GH_ARCHIVE_SHA256" {
  default = "83d5c2ccad5498f58bf6368acb1ab32588cf43ab3a4b1c301bf36328b1c8bd60"
}

variable "IMAGE_PREFIX" {
  default = "local/"
}

variable "IMAGE_VERSION" {
  default = "0.1.0"
}

variable "IMAGE_SOURCE" {
  default = "https://github.com/lxndrp/container-images"
}

variable "IMAGE_REVISION" {
  default = "local"
}

variable "REVISION_SHORT" {
  default = "local"
}

group "default" {
  targets = ["base", "codex", "github"]
}

target "_common" {
  context = "."
  platforms = ["linux/amd64"]
  args = {
    IMAGE_SOURCE = IMAGE_SOURCE
    IMAGE_REVISION = IMAGE_REVISION
    IMAGE_VERSION = IMAGE_VERSION
    UBUNTU_VERSION = UBUNTU_VERSION
    UBUNTU_DIGEST = UBUNTU_DIGEST
  }
}

target "base" {
  inherits = ["_common"]
  dockerfile = "images/base/Dockerfile"
  tags = [
    "${IMAGE_PREFIX}container-base:ubuntu${UBUNTU_VERSION}",
    "${IMAGE_PREFIX}container-base:${IMAGE_VERSION}-ubuntu${UBUNTU_VERSION}",
    "${IMAGE_PREFIX}container-base:sha-${REVISION_SHORT}-ubuntu${UBUNTU_VERSION}",
  ]
}

target "codex" {
  inherits = ["_common"]
  dockerfile = "images/workloads/codex/Dockerfile"
  contexts = {
    base = "target:base"
  }
  args = {
    CODEX_VERSION = CODEX_VERSION
    CODEX_ARCHIVE_SHA256 = CODEX_ARCHIVE_SHA256
  }
  tags = [
    "${IMAGE_PREFIX}codex:ubuntu${UBUNTU_VERSION}",
    "${IMAGE_PREFIX}codex:${CODEX_VERSION}-ubuntu${UBUNTU_VERSION}",
    "${IMAGE_PREFIX}codex:sha-${REVISION_SHORT}-ubuntu${UBUNTU_VERSION}",
  ]
}

target "github" {
  inherits = ["_common"]
  dockerfile = "images/environments/github/Dockerfile"
  contexts = {
    codex = "target:codex"
  }
  args = {
    GH_VERSION = GH_VERSION
    GH_ARCHIVE_SHA256 = GH_ARCHIVE_SHA256
  }
  tags = [
    "${IMAGE_PREFIX}codex-github:ubuntu${UBUNTU_VERSION}",
    "${IMAGE_PREFIX}codex-github:${CODEX_VERSION}-ubuntu${UBUNTU_VERSION}",
    "${IMAGE_PREFIX}codex-github:sha-${REVISION_SHORT}-ubuntu${UBUNTU_VERSION}",
  ]
}
