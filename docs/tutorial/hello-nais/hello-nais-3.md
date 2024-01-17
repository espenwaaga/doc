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
