# LocalStack Workbench
AWS Infrastructure Development environment based on LocalStack, Webtop, Jenkins for mocking AWS IaC with terraform


The components provided in this repo can be used as a full development environment to easy start over with Terraform IaC development for a locally mocked AWS account. No need to have access to an actual AWS Account.

[Webtop](https://docs.linuxserver.io/images/docker-webtop/) is used as a KDE based Linux Desktop coming with:
- AWS and IaC CLI tools
- IDEs

A full list of provided tools can be found in the section "Using the Workbench"

[Jenkins](https://www.jenkins.io) container is provided and can be used, eg. for setting up IaC implementation pipelines.

[LocalStack](https://www.localstack.cloud) allows the local simulation of an AWS Account with quite a hugh no. of services supported (even including setting up K8s workloads in EKS) for local mocking of setup of Infrastructure.



## Prerequisites
- Docker environment / Docker Desktop installed and reachable
- docker cli and docker-compose cli installed
- Localstack license obtained (free of costs license available for private evaluation purposes)

## Setup
- Clone git repo
- in root directory of repo execute:
./setup-environment.sh

After the script finished setting up all components, setup of Jenkins needs to be finished. The needed InitialAdminPassword is provided by the installer script
Further hints on Jenkins you can find below.

## Using the Workbench
- Open http://localhost:3000 to access LocalStack Webtop:

![Webtop](resources/webtop.png)

Available Toolset:
- git
- aws
- terraform
- Visual Studio Code
- JetBrains PyCharm Community Edition
- OpenLens
- kubectl, kubectx, kubens

Recommended Plugins for installed IDEs:
- Terraform and HCL
- Docker
- AWS Toolkit (Amazon Q, Code Whisperer)

## Jenkins
Jenkins is installed to allow to set up IaC via terraform automatically via pipeline. Terraform (as arm64 binary) is preinstalled in /opt directory. If the binary does not fit the actual architecture, just replace it in the repos ./configs/jenkins directory with the one fitting your needs.

### installed software
- pipx is preinstalled in Jenkins to allow, e.g. to install terraform-local or other python based tools

### recommended Plugins and tools:
- Terraform plugin
- AnsiColor plugin
- terraform-local (install via pipeline - see below)

### example Pipeline Script
(replace GitHub URL and credentials with proper data)

    pipeline {
        agent any
        options {
            ansiColor('xterm')
        }
        stages {
            stage('GitHub Checkout') {
                steps {
                    script {
                        checkout scmGit(branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[credentialsId: 'credentialsid', url: 'git@github.com:username/repo.git']])
                    }
                }
            }
            stage('Install tflocal') {
                steps {
                    script {
                        sh '/usr/bin/pipx install terraform-local'
                    }
                }
            }
            stage('Terraform Init') {
                steps {
                    script {
                        sh 'LOCALSTACK_HOSTNAME=localhost.localstack.cloud /root/.local/bin/tflocal init -reconfigure'
                    }
                }
            }
            stage('Terraform Plan') {
                steps {
                    script {
                        sh 'LOCALSTACK_HOSTNAME=localhost.localstack.cloud /root/.local/bin/tflocal plan -out=tfplan'
                    }
                }
            }
            stage('Terraform Apply') {
                steps {
                    script {
                        sh 'LOCALSTACK_HOSTNAME=localhost.localstack.cloud /root/.local/bin/tflocal apply tfplan'
                    }
                }
            }
        }
    }

### Hints
Basically terraform can be used to set up resources in localstack. But using terraform with S3 configured as backend for tfstate file leads to authorization (443) errors when trying to do terraform init.

Therefore LocalStack tflocal wrapper script (terraform-local) can be used to overcome this restriction (see example pipeline).


# Todo
- Jenkins: preinstall terraform in Jenkins container automatically via Dockerfile
