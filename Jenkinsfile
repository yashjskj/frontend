pipeline {
    agent any
    environment {
        DOCKER_IMAGE = 'yashjskj/frontend:latest'
    }
    stages {
        stage('Build Docker Image') {
            steps {
                script {
                    sh 'docker build -t $DOCKER_IMAGE .'
                }
            }
        }
        stage('Push to Docker Registry') {
            steps {
                script {
                    withDockerRegistry([credentialsId: 'docker-credentials', url: '']) {
                        sh 'docker push $DOCKER_IMAGE'
                    }
                }
            }
        }
        stage('Deploy to Kubernetes') {
            steps {
                script {
                    sh 'kubectl apply -f k8s/frontend-deployment.yaml --validate=false'
                    sh 'kubectl apply -f k8s/frontend-service.yaml --validate=false'
                }
            }
        }
    }
}

