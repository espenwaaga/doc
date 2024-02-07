# Welcome to the NAIS documentation repo

This repository is used to build a [mkdocs](https://www.mkdocs.org/) site for the [NAIS](https://nais.io) project.

All _documentation_ content resides inside the [docs](docs/) folder, with the general structure of the website defined in [mkdocs.yml](mkdocs.yml)'s `nav`-yaml key.

## Conventions

### Documentation structure

The file tree represents the structure of the navigation menu.
The H1 (#) will be the title of the page and the title in the navigation menu

### Placeholder variables

Where the reader is expected to change the content, we use placeholder variables.
These variables are written in uppercase, with words separated by hyphens, surrounded by <>. For example: `<MY-APP>`.

### Tenant variables

We template the tenant name in the documentation using `\<<tenant()>>`
When the documentation is built, this will be replaced with the relevant tenant name.

### Code blocks

We want to use expanded notes with the filename in the title and the code block inside the note. Preferably with syntax highlighting where applicable.
This will give the reader a copy button with the relevant code and the filename will be visible in the navigation menu.

```git
???+ note ".nais/app.yaml"

    ```yaml hl_lines="6-8 11"
    apiVersion: nais.io/v1alpha1
    kind: Application
    ...
    ```
```

### Alternate paths

When the user is given a choice, we want to show both paths in the documentation. For example programming language, OS or different methods

```md
  === "Linux"
    linux specific stuff
  === "macOS"
    macOS specific stuff
```

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
