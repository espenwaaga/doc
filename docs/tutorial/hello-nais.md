# Hello NAIS

This tutorial will take you through the process of getting a simple Kotlin application up and running on NAIS. No previous experience with NAIS is required.


## 0. Prerequisites

- You have a GitHub account connected to your GitHub organization (e.g. `navikt`)
- [naisdevice installed](../how-to/naisdevice/install.md)
- [Member of a NAIS team](../explanation/team.md)
- [GitHub CLI installed](https://cli.github.com/)
- [JDK =>v17 installed](https://adoptium.net)

??? note "Conventions"

    Throughout this guide, we will use the following conventions:
    
    - `<my-app>` - The name of your NAIS application (e.g. `joannas-first`)
    - `<my-org>` - Your GitHub organization (e.g. `navikt`)
    - `<my-team>` - The name of your NAIS team (e.g. `onboarding`)
    
    **NB!** Choose names with *lowercase* letters, numbers and dashes only. 

## 1. Create your own GitHub repository

Create your own repo using the [nais/getting-started](https://github.com/nais/getting-started/) as a template.

You create a new repository through either the [GitHub UI](https://github.com/new?template_name=getting-started&template_owner=nais) or through the GitHub CLI:

```bash
gh repo create <my-org>/<my-repo> --template nais/getting-started --private --clone
```
```bash
cd <my-app>
```

## 2. Grant your team access to your repository

This has to be done in the GitHub UI.

Go to your repository and click on `Settings` -> `Collaborators and teams` -> `Add teams`.

Select your team, and grant them the `Write` role.

## 3. Authorize the repository for deployment

Visit [Console](https://console.{{tenant}}.cloud.nais.io). Select your team, and visit the `Repositories` tab. 

This ensures that the proper permissions are set up by the time you're doing the steps that require them.
Normally, these are automatically synchronized every 15 minutes. If you don't see your repository here, force synchronization by clicking the `Refresh` button.

## 4. Familiarize yourself with the files used

Check out the files in your repository to see what they contain.

`nais.yaml` (TODO) is where you configure your application. For a full list of available configuration options, see the [Application spec](../reference/application-spec.md)-reference.

`Dockerfile` describes the steps needed to build your docker image.

`.github/workflows/main.yaml` is the GitHub Actions workflow that will build and deploy your application to NAIS. You can read more about the GitHub Actions workflow in the [GitHub Actions documentation](https://docs.github.com/en/actions).

## 5. Check that your application is working

Before proceeding, let's make sure that your application is working. Run the following command to start your application:

```bash
./gradlew run
```

Visit [http://localhost:8080](http://localhost:8080) to see your application running.

## 6. Edit the application spec

Open the `nais.yaml` file. It should look something like this:

```yaml title="nais.yaml" hl_lines="6 10" linenums="1"
apiVersion: nais.io/v1alpha1
kind: Application
metadata:
  labels:
    team: onboarding
  name: <my-app>
  namespace: onboarding
spec:
  ingresses:
    - https://<my-app>.intern.dev.nav.no
  image: {{image}}
  port: 8080
  ttl: 3h
  replicas:
    max: 1
    min: 1
  resources:
    requests:
      cpu: 50m
      memory: 32Mi
```

For the highlighted lines (line 6 and 10):

Replace all occurrences of `<my-app>` with the name of your application, for example:

```yaml
metadata:
  name: joannas-first
spec:
  ingresses:
    - https://joannas-first.intern.dev.nav.no
```

## 7. Commit and push your changes

Now that you have made some changes to your repository, it's time to commit and push them to GitHub.

```bash
git add .
git commit -m "<Change-message>"
git push origin main
```

## 8. Observe the GitHub Actions workflow

When pushed, the GitHub Actions workflow will automatically start. You can observe the workflow by running the following command:

```bash
gh run watch
```

or 

```bash
gh repo view --web
```

and click on the `Actions` tab.

## 9. Visit your application

When the workflow is finished, you can visit the application on the following URL:

```
https://<my-app>.intern.dev.nav.no
```

## 10. Cleanup

When you are finished with this guide you can delete your repository:

```bash
gh repo delete <my-org>/<my-app>
```
