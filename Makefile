.PHONY: build
build:
	bash ./build.sh

# Build only the protoc-all image locally for development. Tags as
# taxime/protoc-all:fork so taxime-hq/protos's `make gen-local` can pick it up
# without needing AWS/ECR credentials. Each invocation overwrites the previous
# :fork tag.
.PHONY: build-local
build-local:
	NAMESPACE=taxime BUILDS=protoc-all bash ./build.sh
	@bash -c '. ./variables.sh && docker tag taxime/protoc-all:$$VERSION taxime/protoc-all:fork'
	@echo "==> Built taxime/protoc-all:fork"

.PHONY: test
test:
	bash ./all/test.sh

.PHONY: test-gwy
test-gwy:
	bash ./gwy/test.sh

# Not for manual invocation.
.PHONY: push
push: build
	bash ./push.sh

# Not for manual invocation; see .github/workflows/release.yml.
.PHONY: push-latest
push-latest:
	bash ./push.sh true

.PHONY: tag-latest
tag-latest:
	bash ./build.sh true
