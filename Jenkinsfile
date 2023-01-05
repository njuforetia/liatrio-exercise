pipeline {
    agent any
    triggers{
        pollSCM('* * * * *')
        }

    options{
    timestamps()
    buildDiscarder(logRotator(artifactDaysToKeepStr: '', artifactNumToKeepStr: '2', daysToKeepStr: '', numToKeepStr: '2'))
        }
    stages{
        stage('Checkout'){
            steps{
                sh "echo this is checkout stage"
	            git branch: 'main', credentialsId: '8e348aa2-9531-4dbe-863d-1adb64897470', url: 'https://github.com/LandmakTechnology/maven-web-application.git'
	        }
        }
        stage('BuildDockerImage'){
            steps{
                sh "echo build docker image"
                sh "docker build -t genedemo/flaskapp:latest . "
                sh "echo push docker image to dockerHub"
            }
        }
        stage('PushDockerImage'){
            steps{
                sh "docker push genedemo/flaskapp:latest"
            }          
        }

        stage('ProvisionEKSInfrastructure'){
            steps{
                sh "echo provision eks infrastructure"
                sh "cd k8s-aws-eks"
                sh "terraform init"
                sh "terraform plan"
                sh "terraform apply -auto-approve"
            }
        }
        stage('Deploy'){
            steps{
                sh "echo deploy to kubernetes"
                
                sh "kubectl apply -f liatrio-app-deployment.yaml"
            }
        }
    }
}