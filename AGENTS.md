# Notes for AI coding assistants

This repo builds `juaningles/perl` — an Alpine-based Perl Docker image with a
large fixed set of CPAN modules (HTTP/HTTPS via LWP, XML/JSON/YAML/CSV, DBI
drivers, SOAP/ServiceNow, REST, OAuth2, Azure Blob). See README.md for the
user-facing docs; this file records the invariants and gotchas that are easy
to break.

## Commands

```sh
make build                                   # build juaningles/perl:build from alpine:3
make test                                    # run test.pl inside the image
make build BASE_IMAGE=alpine:edge VERSION=edge   # build against another base
make tag-perl-version                        # tag image with the perl version it contains
make build-dev                               # every && becomes its own layer, for debugging
```

A full uncached build takes ~15–25 minutes (cpanm compiles XS modules).
`docker` may actually be podman emulation on the dev machine — both work.

## Invariants — read before editing the Dockerfile

1. **Two-stage build.** The builder stage compiles CPAN modules with the full
   toolchain; the runtime stage installs only runtime apk packages and copies
   `/usr/local/share/perl5/site_perl`, `/usr/local/lib/perl5/site_perl`, and
   `/usr/local/bin/` from the builder.
2. **`perl-*` apk packages must be added to BOTH stages.** The builder needs
   them so later cpanm steps see their dependencies; the runtime stage needs
   them because apk-installed files are NOT covered by the site_perl COPYs.
   A package present only in the builder will make `perl test.pl` fail at the
   end of the runtime stage.
3. **cpanm modules go ONLY in the builder.** They land in site_perl and reach
   the runtime image via the COPY lines automatically.
4. **Every provided module has a `use` line in `test.pl`.** That script runs
   as the last step of the runtime stage, so the build itself is the smoke
   test. Adding a module without adding it to test.pl means it is untested;
   removing one without pruning test.pl breaks the build.
5. **Do not reorder the install steps in the builder.** Later cpanm installs
   depend on modules installed by earlier lines (the interleaved apk/cpanm
   order is deliberate).
6. **Do not add cleanup to either stage.** No `apk del`, no `rm -rf` of cpanm
   caches — the multi-stage split already keeps all build debris out of the
   final image. Cleanup in the builder only slows rebuilds.
7. **Known quirks:** `cpanm XML::Parser::Lite` needs `--force` (test
   failures). `Net::SSLeay` requires `openssl`, `openssl-dev`, and `zlib-dev`
   in the builder (its build broke on alpine 3.24 without them — commit
   36d3a37). `make` and `openssl` are kept in the runtime image on purpose so
   `cpanm` still works for pure-Perl modules inside a container.

## Versioning

- The Perl version is determined by the Alpine release (`BASE_IMAGE`):
  `alpine:3` → current stable, `alpine:edge` → newest, `alpine:3.22` → 5.40,
  `alpine:3.20` → 5.38.
- Tags: `build` is a local scratch tag, `latest` is the blessed release, and
  numeric tags (`5.42.2`, …) are created by `make tag-perl-version`, which
  reads the version out of the built image — never hand-type a version tag.
- Rebuilding the same Perl version silently moves its numeric tag to the new
  image; use a `-rN` suffix if rebuilds must stay distinguishable.

## Adding a module — checklist

1. Prefer an Alpine `perl-*` apk package if one exists; otherwise `cpanm`.
2. apk package → add to the builder (in dependency order) AND to the runtime
   stage's apk RUN. cpanm module → builder only.
3. Add a `use` line to `test.pl`.
4. `make build && make test` (use `make build-dev` to bisect a failing step).
5. Update the module list in README.md if it changes what the image is for.
