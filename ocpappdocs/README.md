## How to deploy OCP apps

OCP apps are just Kubernetes resources grouped by a label such as `app=` or `app.kubernetes.io/part-of=`. So if you know how to create Kubernetes resources then you already know how to create OCP apps.

Let's take for example this Deployment resource (deployment.yaml) which is from [here](https://github.com/fxiang1/app-samples/tree/main/helloworld) :
```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: helloworld-app-deploy
spec:
  selector:
    matchLabels:
      app: helloworld-app
  replicas: 1
  template:
    metadata:
      labels:
        app: helloworld-app
    spec:
      containers:
      - name: helloworld-app-container
        image: "quay.io/fxiang1/helloworld:0.0.1"
        imagePullPolicy: IfNotPresent
        ports:
          - containerPort: 3002
        env:
          - name: "PORT"
            value: "3002"
        resources:
          limits:
            cpu: 200m
            memory: 256Mi
          requests:
            cpu: 50m
            memory: 64Mi
```

If we were to create it as-is in OCP by running:
```
oc apply -f deployment.yaml
```

it would not be recognized as an OCP app. However, if we add the label `app` or `app.kubernetes.io/part-of` to it then the App UI would be able to recongize it as an OCP app:

```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: helloworld-app-deploy
  labels:
    app: helloworld-app                             <------- New label
spec:
  selector:
    matchLabels:
      app: helloworld-app
  replicas: 1
  template:
    metadata:
      labels:
        app: helloworld-app
    spec:
      containers:
      - name: helloworld-app-container
        image: "quay.io/fxiang1/helloworld:0.0.1"
        imagePullPolicy: IfNotPresent
        ports:
          - containerPort: 3002
        env:
          - name: "PORT"
            value: "3002"
        resources:
          limits:
            cpu: 200m
            memory: 256Mi
          requests:
            cpu: 50m
            memory: 64Mi
```

In this case `helloworld-app` would be the app name and what displays on the app table.

Here are the top level deploy resources that are supported:
```
deployment
deploymentconfig
statefulset
daemonset
cronjob
job
```

One thing to note is that your app will only appear on the app table if it's accompanied by one of the top level deploy resources above. So let's say if you were to just deploy an app with a `ConfigMap` resource and added a label to it then it will not be recongized as an app and will not be displayed on the app table. However, even though the app will not show up in the table, it will still display in the topology if you construct the URL manually.
