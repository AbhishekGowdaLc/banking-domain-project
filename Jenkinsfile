pipeline {
    agent any

    tools {
        maven "MY_MAVEN"
    }

    stages {
      stage('prepare environment'){
         steps{
          echo 'Initialize the variables'
          docker = tool name: 'MY_DOCKER' , type: 'org.jenkinsci.plugins.docker.commons.tools.DockerTool'
          tagName = "1.0"
         }
      }
        stage('checkout') {
            steps {
              
                   git 'https://github.com/AbhishekGowdaLc/banking-domain-project'
            
                }
            }
        stage('build') {
              steps {
              
                     sh "mvn clean package"
                }
        }
        
        stage('publish HTML reports') {
              steps {
                    publishHTML([allowMissing: false, alwaysLinkToLastBuild: false, keepAll: false, reportDir: '/var/lib/jenkins/workspace/banking-domain-project/target/surefire-reports', reportFiles: 'index.html', reportName: 'banking-project-HTML Report', reportTitles: '', useWrapperFileDirectly: true])
                }
        }
        
          stage('build docker image') {
              steps {
                  
                  sh'sudo docker system prune -af '
                sh "${dockerCMD} build -t abhishekgowda123/bankingproject:${tagName} ."
              
                }
            }
                
        stage('push image to dockerhub') {
              steps {
                 echo 'pushing docker image'
                 withCredentials([string(credentialsId: 'docker-password', variable: 'DockerPassword')]) {
                 sh "${dockerCMD} login -u abhishekgowda123 -p ${DockerPassword}"
                 sh "${dockerCMD} push abhishekgowda123/bankingproject:${tagName}"
                  }
                }
         }
                
        stage ('deployment server & image deployment'){
            steps{

                dir('deploymentServer'){
                sh 'sudo chmod 600 abhishek.pem'
                sh 'terraform init'
                sh 'terraform validate'
                sh 'terraform apply --auto-approve'
                }
               
            }
        }

        stage('waiting time') {
              steps {
                  
                  sh ' sleep 50'
                           
                }
            }
       
        stage('selenium-automation-test') {
              steps {
                  
                  sh 'sudo java -jar bankingproject.jar'
                  sh"echo 'excuetion is successfull' "
                           
                }
            }
          }
        }

