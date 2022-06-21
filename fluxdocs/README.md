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

7. Use this command to see if the kustomization is applied
```
flux get kustomizations --watch
```

### Helm sample

For Helm, after you create the bootstrap you can deploy the app by using the sample files from the `helmapp` dir. Create the Helm repo first and then the Helm release.

When you try to create the resource it might fail due to the policy settings. To workaround this you need to set both Kyverno ClusterPolicies to ignore on fail and failure action to audit:
```
enforce-define-serviceaccount-policy
enforce-same-namespace-policy
```

For example:
```
apiVersion: kyverno.io/v1
kind: ClusterPolicy
metadata:
  annotations:
    pod-policies.kyverno.io/autogen-controllers: none
    policies.kyverno.io/category: Other
    policies.kyverno.io/severity: medium
    policies.kyverno.io/title: Enforce Service Account is Defined
  creationTimestamp: '2022-06-07T16:09:57Z'
  generation: 6
  labels:
    kustomize.toolkit.fluxcd.io/name: policies-kyverno
    kustomize.toolkit.fluxcd.io/namespace: flux-system
  name: enforce-define-serviceaccount-policy
  resourceVersion: '48309589'
  uid: 142d96e5-dc8c-4f92-ba35-3c2b4285cc34
spec:
  background: false
  failurePolicy: Fail                                                  <------ Change to Ignore
  rules:
    - exclude:
        any:
          - resources:
              namespaces:
                - flux-system
      match:
        any:
          - resources:
              kinds:
                - helm.toolkit.fluxcd.io/v2beta1/HelmRelease
                - kustomize.toolkit.fluxcd.io/v1beta2/Kustomization
      name: serviceaccount-name
      validate:
        message: serviceAccountName must be specified
        pattern:
          spec:
            serviceAccountName: '?*'
  validationFailureAction: enforce                                    <------- Change to audit
status:
  conditions:
    - lastTransitionTime: '2022-06-07T16:09:59Z'
      message: ''
      reason: Succeeded
      status: 'True'
      type: Ready
  ready: true
```

### Bucket sample

It looks like Flux only provides the ability to source(load) resources from Buckets but cannot deploy them. You need to write your controller to deploy the resources.
