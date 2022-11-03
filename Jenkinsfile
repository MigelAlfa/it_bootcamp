pipeline {
    environment {
      registry = "migelalfa/it_boot"
      registryCredential = 'dockerhub'
    }
    agent any
    stages {
      stage('Cloning Git') {
        steps {
           git branch: 'main', url: 'https://github.com/MigelAlfa/it_bootcamp.git'          
        }
      }
          stage ("Lint dockerfile") {
        agent {
            docker {
                image 'hadolint/hadolint:latest-debian'
                //image 'ghcr.io/hadolint/hadolint:latest-debian'
            }
        }
        steps {
            sh 'hadolint Dockerfile | tee -a hadolint_lint.txt'
        }
        post {
            always {
                archiveArtifacts 'hadolint_lint.txt'
            }
        }
    }
      stage('Building image') {
        steps{
          script {
            //dockerImage = docker.build registry + ":$BUILD_NUMBER" , "."
            //dockerImage = docker.build registry + ":$BUILD_NUMBER" , "--network host ."
            dockerImage = docker.build registry + ":latest" , "."
          }
        }
      }
      stage('Test image') {
        steps{
          sh "docker inspect $registry:latest"

        }
      }
    
      stage('Push img') {
        steps{
          script {
            docker.withRegistry( '', registryCredential ) {
              dockerImage.push()
            }
          }
        }
      }
      stage('Deploy in pre-prod') {
      steps{
        script {
          sh "kubectl apply -f jenkins_21.yaml --namespace=pre-prod"
          sleep 4
          sh "kubectl get pods --namespace=pre=prod"
        }
      }
    }
    stage('Deploy in prod') {
      steps{
        script {
          catchError(buildResult: 'SUCCESS', stageResult: 'FAILURE'){
            def depl = true
            try{
              input("Deploy in prod?")
            }
            catch(err){
              depl = false
            }
            try{
              if(depl){
                sh "kubectl apply -f jenkins_21.yaml"
                sleep 4
                sh "kubectl get pods --namespace=prod"
                sh "kubectl delete -f jenkins_21.yaml --namespace=pre-prod"
              }
            }
            catch(Exception err){
              error "Deployment filed"
            }
          }
        }
      }
    }  
  }
  post {
    success {
      slackSend (color: '#00FF00', message: "Deployment success: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'")
    }
    failure {
      slackSend (color: '#FF0000', message: "Deployment failed: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'")
    }
  }
}