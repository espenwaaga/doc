# Hello NAIS

This tutorial will take you through the process of getting a simple Kotlin application up and running on NAIS. No previous experience with NAIS is required.

## 0. Prerequisites

- You have a GitHub account connected to your GitHub organization (e.g. `navikt`)
- [naisdevice installed](../how-to/naisdevice/install.md)
- [Member of a NAIS team](../explanation/team.md)
- [GitHub CLI installed](https://cli.github.com/)
- [JDK =>v17 installed](https://adoptium.net)

???+ note "Conventions"

    Throughout this guide, we will use the following conventions:
    
    - `<my-app>` - The name of your NAIS application (e.g. `joannas-first`)
    - `<my-team>` - The name of your NAIS team (e.g. `onboarding`)
    - `<github-org>` - Your GitHub organization (e.g. `navikt`)
    - `<target-cluster>` - The name of the cluster you want to deploy to (e.g. `dev`)
    
    **NB!** Choose names with *lowercase* letters, numbers and dashes only. 

## 1. Create your own GitHub repository

Create your own repo using the [nais/getting-started](https://github.com/nais/getting-started/) as a template.

You create a new repository through either the [GitHub UI](https://github.com/new?template_name=getting-started&template_owner=nais) or through the GitHub CLI:

```bash
gh repo create <github-org>/<my-repo> --template nais/getting-started --private --clone
```
```bash
cd <my-app>
```

## 2. Grant your team access to your repository

This has to be done in the GitHub UI.

Go to your repository and click on `Settings` -> `Collaborators and teams` -> `Add teams`.

Select your team, and grant them the `Write` role.

## 3. Familiarize yourself with the repository

Check out the files in your repository to see what they contain.

`Dockerfile` describes the steps needed to build your docker image.

`.github/workflows/main.yaml` is the GitHub Actions workflow that will be used to build and deploy your application to NAIS. This file currently only contain steps to build the JAR-file. The rest of the steps will be added later in the tutorial. 

You can also verify that the application is working by running the following command:

```bash
./gradlew run
```

Visit [http://localhost:8080](http://localhost:8080) to see your application running.

## 4. Create the NAIS Application yaml file

Create a file called `app.yaml` in a `.nais`-folder.

```bash
mkdir .nais
touch .nais/app.yaml
```

Add the following content to the file, and insert the appropriate values in the placeholders on the highlighted lines:

```yaml title="nais.yaml" hl_lines="5 6 7 10" 
apiVersion: nais.io/v1alpha1
kind: Application
metadata:
  labels:
    team: <my-team>
  name: <my-app>
  namespace: <my-team>
spec:
  ingresses:
    - https://<my-app>.external.<target-cluster>@@TENANT@@.internal.cloud.nais.io
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

This file describes your application to the NAIS platform so that it can run it correctly and provision the resources it needs.
For a full list of available configuration options, see the [Application spec](../reference/application-spec.md)-reference.

## 5. Add the NAIS build and deploy actions to your workflow

For this step, we will use the description in the [Build and deploy with Github Actions](../how-to/cicd/github-action.md) guide.

Since we already have a workflow file, we will only add the missing steps provided in the guide.

## 6. Authorize the repository for deployment

Visit [Console](https://console.{{tenant}}.cloud.nais.io). Select your team, and visit the `Repositories` tab. 

This ensures that the proper permissions are set up by the time you're doing the steps that require them.
Normally, these are automatically synchronized every 15 minutes. If you don't see your repository here, force synchronization by clicking the `Refresh` button.

## 7. Commit and push your changes

Now that you have made some changes to your repository, it's time to commit and push them to GitHub.

```bash
git add .
git commit -m "Add nais app.yaml and add build and deploy steps to workflow"
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
https://<my-app>.external.<target-cluster>.$$TENANT$$.internal.cloud.nais.io
```

## 10. Cleanup

When you are finished with this guide you can delete your repository:

```bash
gh repo delete <github-org>/<my-app>
```
