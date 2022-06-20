## How to deploy FluxCD apps

### Git sample

0. Setup Git creds
```
export GITHUB_USER=<git_user>
export GITHUB_TOKEN=<git_token>
```

1. Create a Git repo for flux as it needs one to store the application definition
```
flux bootstrap github \
  --owner=$GITHUB_USER \
  --repository=helloworld-flux \
  --branch=main \
  --path=./clusters/my-cluster \
  --personal
```

Creating multiple bootstraps is not supported, so once created just need to add more repos or kustomizations see below.

2. Clone the Git repo
```
git clone https://github.com/$GITHUB_USER/helloworld-flux
cd helloworld-flux
```

3. This is like the channel resource for subscription apps
```
flux create source git app-samples \
  --url=https://github.com/fxiang1/app-samples \
  --branch=main \
  --interval=30s \
  --export > ./clusters/my-cluster/helloworld-source.yaml
```

4.
```
git add -A && git commit -m "Add app-samples GitRepository"
git push
```

5. Tells the app which folder in Git to deploy from
```
flux create kustomization helloworld \
  --target-namespace=feng-flux \        <-- need to create namespace first, not sure if there's auto-create namespace option like Argo
  --source=app-samples \
  --path="./helloworld" \
  --prune=true \
  --interval=5m \
  --export > ./clusters/my-cluster/helloworld-kustomization.yaml
```

6. Push the kustomization change to deploy the app
```
git add -A && git commit -m "Add helloworld Kustomization"
git push
```
