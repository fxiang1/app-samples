# How to deploy

Requirements:
- Make sure you have the oc CLI 4.3 or above installed.

The application resources are stored in **sample-*** folders in this repo.

To deploy a sample, do the following:

1. git clone https://github.com/fxiang1/app-samples.git

2. oc login to your hub cluster

3. cd app-samples

4. oc apply -k sample-mortgage

Most of the application resources are using this git repo although some are pointing to external repos.
