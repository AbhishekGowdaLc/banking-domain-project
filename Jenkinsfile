   node {
    def mavenHome
    def mavenCMD
    def docker
    def dockerCMD
    def tagName
    
    stage('jenkins env setup'){
        echo 'Initialize the variables'
        mavenHome = tool name: 'myMaven' , type: 'maven'
        mavenCMD = "${mavenHome}/bin/mvn"
        docker = tool name: 'myDocker' , type: 'org.jenkinsci.plugins.docker.commons.tools.DockerTool'
        dockerCMD = "${docker}/bin/docker"
        tagName = "1.0"
    }
    stage ('checkout'){
        try{
        echo 'pulling the code from github repo'
        git 'https://github.com/AbhishekGowdaLc/starAgile-bankingFinance'
        }
        catch(Exception e){
            echo 'Exception Occur'
            currentBuild.result = "FAILURE"
            emailext body: '''Hello Staragile Deveops
            The Build Number ${BUILD_NUMBER} is Failed. Please look into that.
            Thanks,''', subject: 'The jenkis Job ${JOB_NAME} is Failed ', to: 'gowda12381@gmail.com'
        }
    }
    stage('Build the application'){
        echo 'clean,compile,test & package'
            sh "${mavenCMD} clean package"
    }
    stage('publish html reports'){
        publishHTML([allowMissing: false, alwaysLinkToLastBuild: false, keepAll: false, reportDir: '/var/lib/jenkins/workspace/StrarAgileDevopsPipeline/target/surefire-reports', reportFiles: 'index.html', reportName: 'HTML Report Staragile/var/lib/jenkins/workspace/StrarAgileDevopsPipeline', reportTitles: '', useWrapperFileDirectly: true])
    }
    stage('create DockerImage'){
        try{
        echo 'creating the docker image'
		
        sh "${dockerCMD} build -t abhishekgowda123/banking-project:1.0 ."
        
        }
        catch(Exception e){
            echo 'Exception Occur'
            currentBuild.result = "FAILURE"
            emailext body: '''Hello Staragile Deveops
            The Build Number ${BUILD_NUMBER} is Failed. Please look into that.
            Thanks,''', subject: 'The jenkis Job ${JOB_NAME} is Failed ', to: 'gowda12381@gmail.com'
            
        }
    }
    stage('push the docker image to dockerhub'){
        echo 'pushing docker image'
        withCredentials([string(credentialsId: 'docker-password', variable: 'DockerPassword')]) {
        sh "${dockerCMD} login -u abhishekgowda123 -p ${DockerPassword}"
        sh "${dockerCMD} push abhishekgowda123/banking-project:1.0"
        }
    }
	   
   stage (' configuring Test-server with terraform & ansible and deploying'){
           

                dir('test-server'){
                sh 'sudo chmod 600 DEMOKEY.pem'
                sh 'terraform init'
                sh 'terraform validate'
                sh 'terraform apply --auto-approve'
		}
               
            }
  stage (' configuring prod-server with terraform & ansible and deploying'){
            steps{

                dir('prod-server'){
                sh 'sudo chmod 600 DEMOKEY.pem'
                sh 'terraform init'
                sh 'terraform validate'
                sh 'terraform apply --auto-approve'
                }
               
            }
   }
