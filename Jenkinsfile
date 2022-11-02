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
            dockerImage = docker.build registry + ":$BUILD_NUMBER" , "."
            //dockerImage = docker.build registry + ":$BUILD_NUMBER" , "--network host ."
            //dockerImage = docker.build registry + ":latest" , "."
          }
        }
      }

    stage('Test image') {
      steps{
        sh "docker run -i $registry:$BUILD_NUMBER"
      }
    }

      stage('Deploy Image') {
        steps{
          script {
            docker.withRegistry( '', registryCredential ) {
              dockerImage.push()
            }
          }
        }
      }
      stage('Remove Unused docker image') {
        steps{
          sh "docker rmi $registry:$BUILD_NUMBER"
        }
      }
    }
  }