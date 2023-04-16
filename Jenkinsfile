 pipeline {
    agent any

    tools {
        maven "MAVEN_HOME"
    }

    stages {
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
                  
                  sh'sudo docker system prune -a'
                  sh 'sudo docker build -t abhishekgowda123/bankingproject:1.0 .'
              
                }
            }
                
        stage('push image to dockerhub') {
              steps {
                   withCredentials([string(credentialsId: 'docpass', variable: 'docpasswd')]) {
                  sh 'sudo docker login -u abhishekgowda123 -p ${docpasswd} '
                  sh 'sudo docker push abhishekgowda123/bankingproject:1.0 .'
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

