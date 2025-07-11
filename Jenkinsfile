pipeline {
    agent any

    environment {
        IMAGE_NAME = "ddubeyyy/smartbus-tracker"
    }

    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/ddubeyyy/SmartBusTracker.git'
            }
        }

        stage('Build WAR') {
            steps {
                sh 'mvn clean package'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t $IMAGE_NAME .'
            }
        }

        stage('Push to Docker Hub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-credentials', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh 'echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin'
                    sh 'docker push $IMAGE_NAME'
                }
            }
        }

        stage('Deploy') {
            steps {
                sh 'docker stop smartbus || true'
                sh 'docker rm smartbus || true'
                sh 'docker run -d --name smartbus -p 8080:8080 $IMAGE_NAME'
            }
        }
    }
}
