
# Docker build environment

A custom LaTeX build environment based on *Debian stable* has been developed
using *Docker* based container technologies. The purpose of this container
is to facilitate LaTeX document generation using Gitlab CI/CD pipelines. The
same image can also be used for generating documents either using the standard
command line prompt or as a backend for new middleware.

The container's TeX distribution is based on
[TinyTeX](https://yihui.org/tinytex/) + TeX 'small' scheme + additional
packages. See the [`Dockerfile`](Dockerfile) for a full list of installed
TeX packages. In addition, a headless Java JRE is provided for
[VeraPDF](https://verapdf.org/) powered PDF/A validation, poppler utils
for analyzing the generated PDF files (`pdfinfo`, `pdffonts` etc.), and
python3 + pygments for pretty printing source code using the LaTeX
[minted](https://ctan.org/pkg/minted) package.

Docker image available at Docker Hub: https://hub.docker.com/repository/docker/konttipoju/tinytex


## Setting up Gitlab CI/CD

The project's [Gitlab CI script](.gitlab-ci.yml) provides an rather complex
example of using the Docker image in Gitlab in various ways (building documents,
asserting certain properties, validating PDF/A conformance).

[This simplified version](.gitlab-ci-simple.yml) can be used instead:

```yaml
# see https://hub.docker.com/repository/docker/konttipoju/tinytex
image: konttipoju/tinytex:2019-12g

# first we build the PDF, then validate it
stages:
  - build
  - validate

# build latex/thesis.tex -> latex/thesis.pdf using pdflatex
# shell-escape functionality is required by the minted package
build:
  script:
    - cd latex
    - latexmk -pdf --shell-escape thesis.tex
artifacts:
  paths:
    - latex/thesis.pdf

# a validation prints "PASS + something" is the file is PDF/A conformant
validate:
  script:
    - pdfa-validate latex/thesis.pdf|grep '^PASS'
```

You're also free to consider other LaTeX Docker images such as these:
 * https://github.com/blang/latex-docker
 * https://github.com/natlownes/docker-latex


## Installing new TeX packages

If a certain package is missing, the Dockerfile can be modified, but adding few
extra packages is even simpler by just invoking `tlmgr`:

```bash
$ tlmgr install packagename
```

The packages can be installed even inside the CI script. However, in case the
document will be recompiled multiple times, generating a new Docker image and
caching it locally is recommended. Otherwise the public repositories might
block access to fight the bandwidth costs.

### Validating PDF/A conformance

A headless Java 11 JRE is provided in the Docker image for VeraPDF powered
PDF/A validation:

```bash
$ pdfa-validate thesis.pdf
```

See the [PDF/A page](web/pdfa.md) for further instructions.

## Compiling the thesis using Docker

We assume the thesis is located in the local folder `thesis/`. The currently
active user also needs to belong in the 'docker' group. Otherwise try
`sudo docker` in place of plain `docker`. In addition, the Docker
service needs to be active (try `systemctl start docker`).

The build environment first needs to be fetched from Docker Hub:

```bash
$ docker pull konttipoju/tinytex:2019-12g
```

We can then list all the available container images:
```bash
$ docker images
REPOSITORY           TAG                 IMAGE ID            CREATED             SIZE
konttipoju/tinytex   2019-12g            4e7da92afcfa        2 hours ago         765MB
debian               buster-slim         2dbffcb4f093        4 weeks ago         69.2MB
```

An interactive shell can be launched in the LaTeX container. This shell
provides access to compile the thesis:

```
$ docker container run -it --mount type=bind,source=$(pwd)/thesis,target=/thesis  4e7da92afcfa /bin/bash
root@d662b10721e7:/var/local# cd /thesis
root@d662b10721e7:/tex# latexmk -pdf --shell-escape thesis.tex
```

The results of the compilation will be available in the `thesis/` directory.
In case the compilation succeeds and the document was compiled in the `final`,
not `draft` mode, the resulting `thesis.pdf` should be a PDF/A conformant
final version.
