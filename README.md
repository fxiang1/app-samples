# Mortgage App

This project is a simple WebSphere web app that accepts mortgage request information
and determines approval.

There are two built in users; bob and deb.  Any password will work.  Bob always gets
his loans approved, and deb never does.

# Move to Channel and Subscription framework

Starting with version 1.0.3 the mortgage app has moved to the Channel and Subscription framework in order to run on MCM.

# How to deploy

Requirements:
Make sure you have the oc CLI 4.3 or above installed.

The application resources are stored in sample-* folders in this repo.

To deploy a sample, do the following:

1. git clone https://github.com/fxiang1/app-samples.git

2. cd app-samples

3. oc apply -k sample-mortgage

Most of the application resources are using this git repo although some are pointing to external repos.
