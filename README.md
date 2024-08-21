# Sonarqube Docker Terraform

SonarQube, running on Docker in EBS, managed by Terraform.

## Usage

Sonarqube is defined as a docker container in `files/docker-compose.yml`

Everything under `files/` is zipped and deployed as a version on ELB.

## Terraform

```
$ terraform init

$ terraform plan

$ terraform apply
```