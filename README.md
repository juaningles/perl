# perl

An Alpine-based Perl Docker image with a batteries-included set of CPAN
modules for HTTP/HTTPS clients (LWP with SSL), XML/JSON/YAML/CSV processing,
databases (DBI with Pg, MySQL, SQLite, ODBC, CSV drivers), SOAP
(SOAP::Lite, ServiceNow::SOAP), REST::Client, OAuth2, logging, and Azure
Blob storage.

Modules come from Alpine `perl-*` apk packages where available, with the
rest installed via `cpanm`. The Dockerfile is a two-stage build: a builder
stage with the full toolchain (gcc, musl-dev, openssl-dev, zlib-dev) compiles
the CPAN modules, and the runtime stage installs only the runtime apk
packages and copies the cpanm-built module trees across
(`/usr/local/{share,lib}/perl5/site_perl` plus the scripts in
`/usr/local/bin`). This keeps the final image small (~87 MB) and gives real
layer caching — a failing cpanm step no longer restarts the whole install.
The image runs as the non-root `user` account and `test.pl` (which loads
every provided module) is executed as the final build step, so a successful
build is a passing smoke test.

## Building

```sh
make build          # build juaningles/perl:build from alpine:3
make test           # run test.pl inside the built image
```

The base image is a build argument. Since Alpine pins its Perl per release,
choosing the base is how you choose the Perl version:

```sh
make build BASE_IMAGE=alpine:edge VERSION=edge    # newest/pre-release Perl
make build BASE_IMAGE=alpine:3.22 VERSION=5.40    # older Perl (5.40)
```

| Base image    | Perl version            |
|---------------|-------------------------|
| `alpine:3`    | 5.42.x (current stable) |
| `alpine:edge` | whatever is newest      |
| `alpine:3.22` | 5.40.x                  |
| `alpine:3.20` | 5.38.x                  |

(Versions as of August 2026 — `make perl-version` reports what an image
actually contains.)

## Versioning and tags

| Tag                  | Meaning                                  | Set by                  |
|----------------------|------------------------------------------|-------------------------|
| `build`              | scratch tag for the current local build  | `make build`            |
| `latest`             | the blessed release                      | `make tag-latest`       |
| `5.42.2`, `5.43.0`, …| per-Perl-version builds                  | `make tag-perl-version` |

`make tag-perl-version` asks the built image which Perl it contains
(`perl -e 'printf("%vd", $^V)'`) and tags it with the answer, so the version
tag always reflects what is actually in the image rather than what was typed
on the command line.

### Testing a newer Perl without touching `build`/`latest`

```sh
make build BASE_IMAGE=alpine:edge VERSION=edge   # build against edge
make test VERSION=edge                           # run test.pl in it
make tag-perl-version VERSION=edge               # -> juaningles/perl:5.43.x
make push VERSION=5.43.0                         # push only the version tag
```

The `edge` scratch tag is throwaway; the Perl-version tag is the durable
artifact. `build` and `latest` are never touched by this flow.

Note: rebuilding from the same base while Alpine still ships the same Perl
moves the version tag to the new image. If rebuilds of the same Perl version
need to stay distinguishable (e.g. security rebuilds), add a suffix such as
`5.42.2-r2`.

## Make targets

| Target             | Description                                              |
|--------------------|----------------------------------------------------------|
| `build`            | Build the image (`BASE_IMAGE`, `VERSION` overridable)    |
| `build-dev`        | Build with each `&&` step as its own layer, for debugging a failing step (tag `$(VERSION)-dev`) |
| `test`             | Run `test.pl` inside the image                           |
| `test-local`       | Run `test.pl` with the host's perl                       |
| `perl-version`     | Print the Perl version inside the built image            |
| `tag-perl-version` | Tag the image with the Perl version it contains          |
| `tag-latest`       | Tag the image as `latest`                                |
| `push`             | Push `$(REPO)$(NAME):$(VERSION)`                         |
| `runit`            | Interactive shell in the image                           |
| `manual_install`   | Print the Dockerfile RUN steps as plain shell commands   |

Variables (override like `make build VERSION=edge`): `VERSION` (default
`build`), `BASE_IMAGE` (default `alpine:3`), `REPO` (default `juaningles/`),
`NAME` (default `perl`).
