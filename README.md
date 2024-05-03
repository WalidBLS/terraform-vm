# terraform-vm

By : Jason Da Cunha - Walid BoulBoul 5IW1

## Description

Use terraform to create a VM in AWS and build a [voting app](https://github.com/dockersamples/example-voting-app) in it.

## Project installation

First add your own AWS access keys and ssh key pair 

#### deploy app

```bash
terraform init
terraform plan
terraform apply
```

#### App access

The urls of voting page and result page are given as output of the terraform apply.
