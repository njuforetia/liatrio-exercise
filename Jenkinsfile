pipeline {
    agent any
    triggers{
        pollSCM('H * * * *')
        }

    options{
    timestamps()
    buildDiscarder(logRotator(artifactDaysToKeepStr: '', artifactNumToKeepStr: '2', daysToKeepStr: '', numToKeepStr: '2'))
        }
    stages{
        stage('Checkout'){
            steps{
                sh "echo this is checkout stage"
                checkout([$class: 'GitSCM', branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/GEN-Guusto/Guusto']]])
            }
	   }
	    stage('TerraformInit'){
            steps{
                sh "echo provision eks infrastructure"
                sh "terraform init"
            }
	     }
	    stage('TerraformPlan'){
	        steps{
	            sh "terraform plan"   
	        }
	      }
        stage('TerraformAction'){
            steps{
                sh "echo terraformAction is -->${action}" 
                sh "terraform ${action} -auto-approve"
            }
        }

    }
}

++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


pipeline {
    agent any
    triggers{
        pollSCM('H * * * *')
        }

    options{
    timestamps()
    buildDiscarder(logRotator(artifactDaysToKeepStr: '7', artifactNumToKeepStr: '3', daysToKeepStr: '7', numToKeepStr: '2'))
        }
        
    stages{
        stage('Checkout'){
            steps{
                sh "echo this is checkout stage"
                checkout([$class: 'GitSCM', branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/njuforetia/liatrio-ex']]])
            }
        }
            
        stage('BuildDockerImage'){
            steps{
                sh "echo build docker image"
                sh "docker build -t genedemo/flaskapp:latest . "

            }
        }
        stage('PushImage'){
            steps{
                sh "echo push docker image to dockerHub"               
                sh "docker push genedemo/flaskapp:latest"
            }
        }
                
        
        
        stage('K8sDeploy'){
            steps{
                sh "echo deploy to kubernetes"
                withKubeConfig(caCertificate: '', clusterName: '', contextName: '', credentialsId: 'K8S', namespace: '', serverUrl: '') {
                }
                //sh "aws eks update-kubeconfig --name main-vpc-cluster --region us-east-1"
                //sh "kubectl create clusterrolebinding cluster-system-anonymus --clusterrole=cluster-admin --user=system:anonymous"
                sh "kubectl apply -f liatrio-app.yml"
            }
        }
    }
}
