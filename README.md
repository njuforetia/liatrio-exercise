# Liatrio-Exercise

## Create a GitHub Repo to commit all codes
### A) Pre-requisite
- Install Git
- Create a GitHub account
- Write the codes described below and commit to GitHub
- Create a repo in Github called Liatrio-exercise (make it public)
- Commit the developed codes

## Developing the Code
### A) Pre-requisite
- Install latest version of Python
- Install python Flask library Flask==2.2.2
- Install python-dotenv==0.21.0 which will be required for running the flask app
- Install gunicorn==20.1.0 which is used as our WSGI server in production
- Create a python application api-py
```
- Run flask app
flask run api.py
```
## Building the Docker Image and Container
### A) Pre-requisite
- Install Docker on ubuntu ~>18.0
- Install Jenkins on same server
- Assign Jenkins user Docker rights to be able to run docker commands
### B) Writing the Dockerfile
- Write a Dockerfile to use for building the container image
- Use Python 3.9 as the base image for building the image
- Expose port 5000 which is the container port (Flask applications run on port 5000). Can change this.
### C) Building the docker image
- To build the image run
```
docker build -t genedemo/flaskapp:latest .
- this builds an image genedemo/flaskapp with tag latest.
- genedemo is the dockerhub account path
- confirm available image by running docker images 
```
### D) Push image to Dockerhub
- Push the image to a remote repository, DockerHub 
- Run the following command
```
docker push genedemo/flaskapp:latest 
you will be required to authenticate to the dockerhub repository using the username and password
```
### E) Create a container for the application
- Create a container for the application called liatrio-app exposing port 5000
- Run the following command
```
docker run --name liatrio-app -d -p 5000:5000 genedemo/flaskapp:latest
- confirm running container with 
docker container ls
```
## Provisioning Infrastructure in AWS using Terraform
### A) Pre-requisite
- Create an Ubuntu instance
- Install Docker
- Install Jenkins
- Install Terraform
- Ensure you have an AWS account
- Create IAM role and grant it Administration Access (Best practice to grant only specific policies e.g. eks access, ec2 access, s3 bucket etc.). Attach IAM role to this instance
- Install AWS CLI
- Install Kubectl
- Authenticate to the Terraform server
### B) Writing the Terraform manifest files
- To provision a kubernetes cluster (EKS cluster)
- Use Terraform resource blocks to write Harshicorp configuration files
- Mkdir k8s-aws-eks to add all the manifest files
  - Use provider aws 
  - use local for state files just to minimize cost for resources with configuring an s3 backend
  - Write a manifest file for the eks master using resource type 'aws_eks_cluster'
  - Write a manifest file for the worker node using the resource type 'aws_eks_node_group'
  - Write a manifest for vpc in order to not provision in the default vpc. 
  - This resource contains the subnets, IGW, Routetables, security groups route tables and route table associations
  - Add other files such as output.tf, variable.tf
  - We are going to use local for our Terraform backend (resource block included for configuring s3 bucket backend with DynamoDB table as lockID) --- for the purpose of minimizing cost for this project.
  - Add ubutu user to docker group so it can run docker commands
  - Add jenkins user to docker group so it can run docker commands
 ### C) Provisioning AWS EKS Infrastructure
 - From the ubuntu server
 - Running teraform commands
 ```
 terraform init - to initialize the backend and the state files
 terraform validate - to validate the syntax of the manifest files
 terraform plan - to show the number of resources to be created (in this case 26 resources)
 terraform apply -auto-approve - to provision the infrastructure in AWS
 terrafor destroy - to destroy infrastructure after it has been provisioned to serve resources/cost
 
 The following attributes are output as part of provisioning
          cluster_name = "main-vpc-cluster"
          region = "us-east-1"

The Two outputs are used to copy the kubeconfig file from kubernetes. 
Run the following to copy the kubeconfig file 
## aws eks update-kubeconfig --name main-vpc-cluster --region us-east-1 
(Enure that your AWS CLI is running the latest version) This copies the kubeconfig from aws to the local repo which allows for the ability to run your k8s CLI (kubectl)
To create rolebinding and assign system:anonymous to enable any user to be able to deploy to k8s cluster, run
## kubectl create clusterrolebinding cluster-system-anonymus --clusterrole=cluster-admin --user=system:anonymous 
```
### D) Deployment
- Create a file called liatrio-app.yaml
  - deployment references the docker image genedemo/flaskapp:latest to deploy the container on the k8s cluster (eks cluster). Deployment kind is 'Deployment'
  - the services allows external access to the deployment outside of the VPC Service type is LoadBalancer.
- Write a kubenertes manifest for kind Deployment and Service with type LoadBalancer
- To deploy to the kubernetes cluster run
```
kubectl apply -f liatrio-app.yaml
check that the deployment is up by running 
kubectl get deployment
check that services is up by running 
kubectl get svc
Use the external DNS generated from the LoadBalancer service to acccess the application on the browser. 
```
## Automation using Jenkins
### A) Pre-requisite
- Install Jenkins on the Docker engine
- Configure Jenkins credential for accessing GitHub (for private repo)
- Configure Jenkins credential to push image to DockerHub  
- Configure Jekins credential for deployment into EKS    
- Install the the following plugins:
  - Docker plugin
  - Docker pipeline plugin
  - Kubenertes CLI plugin is installed for deployment to k8s
- Create credentials in Jenkins to allow access to dockerhub and eks cluster
  - create a credential for dockerhub with ID=dockerhub
  - create a credential for kubernetes with ID=K8s
    Use the kubeconfig file to create a file or enter content directly. Obtain content of kubeconfig file by
    ```
    sudo cat ~/.kube/config
    ```
- Create a jenkinsfile to automate the process (see jenkins file)
- We can either create two separate pipelines (1) for provisioning of eks cluster, and the second for building the image, pushing to dockerhub and deploying into eks.
