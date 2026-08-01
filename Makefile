VERSION = build
NAME = perl
PKG_NAME = perl
REPO ?= juaningles/
BASE_IMAGE ?= alpine:3

.PHONY: all build test tag_latest release ssh push

all: build

build:
	docker build --build-arg BASE_IMAGE=$(BASE_IMAGE) -t $(REPO)$(NAME):$(VERSION) --rm .

build-dev:
	sed -Ez 's/\\[\r,\n]+\s*&&/\nRUN /mg' Dockerfile | docker build --build-arg BASE_IMAGE=$(BASE_IMAGE) -t $(REPO)$(NAME):$(VERSION)-dev  -

push:
	docker push $(REPO)$(NAME):$(VERSION)

test-local:
	env NAME=$(NAME) VERSION=$(VERSION) perl test.pl


test:
	docker run  -it --rm $(REPO)$(NAME):$(VERSION) perl test.pl

run:
	docker run --rm $(NAME):$(VERSION)

runit:
	docker run  -it --rm $(REPO)$(NAME):$(VERSION)

rundev: build-dev
	docker run  -it --rm $(REPO)$(NAME):$(VERSION)-dev

tag-latest:
	docker tag $(REPO)$(NAME):$(VERSION) $(REPO)$(NAME):latest

# Tag the built image with the perl version it actually contains, e.g. juaningles/perl:5.42.2
tag-perl-version:
	docker tag $(REPO)$(NAME):$(VERSION) $(REPO)$(NAME):$$(docker run --rm $(REPO)$(NAME):$(VERSION) perl -e 'printf("%vd", $$^V)')

# Print the perl version inside the built image
perl-version:
	@docker run --rm $(REPO)$(NAME):$(VERSION) perl -e 'printf("%vd\n", $$^V)'

release: test tag_latest
	@if ! docker images $(NAME) | awk '{ print $$2 }' | grep -q -F $(VERSION); then echo "$(NAME) version $(VERSION) is not yet built. Please run 'make build'"; false; fi
	@if ! head -n 1 Changelog.md | grep -q 'release date'; then echo 'Please note the release date in Changelog.md.' && false; fi
	# docker push $(NAME)
	@echo "*** Don't forget to create a tag. git tag rel-$(VERSION) && git push origin rel-$(VERSION)"

ssh:
	chmod 600 image/services/sshd/keys/insecure_key
	@ID=$$(docker ps | grep -F "$(NAME):$(VERSION)" | awk '{ print $$1 }') && \
		if test "$$ID" = ""; then echo "Container is not running."; exit 1; fi && \
		IP=$$(docker inspect $$ID | grep IPAddr | sed 's/.*: "//; s/".*//') && \
		echo "SSHing into $$IP" && \
		ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -i image/services/sshd/keys/insecure_key root@$$IP

manual_install:
	cat Dockerfile | grep "^\s*RUN" | sed -e "s/^\s*RUN\s*//"
