# Welcome to the NAIS documentation repo

This repository is used to build a [mkdocs](https://www.mkdocs.org/) site for the [NAIS](https://nais.io) project.

All _documentation_ content resides inside the [docs](docs/) folder, with the general structure of the website defined in [mkdocs.yml](mkdocs.yml)'s `nav`-yaml key.

## Local development

### install Poetry
```bash
asdf plugin add poetry
asdf install poetry latest
```

### run docs
```bash
make install
make local
```
