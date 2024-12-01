pipeline {
    agent any
    environment {
        DOCKER_IMAGE = 'yashjskj/frontend:latest'
        KUBECONFIG_PATH = "${env.WORKSPACE}/kubeconfig" // Path to write kubeconfig
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
                    // Write Kubernetes credentials (kubeconfig) to a file
                    withCredentials([file(credentialsId: 'minikube-kubeconfig', variable: 'KUBECONFIG_FILE')]) {
                        sh """
                        cp $KUBECONFIG_FILE $KUBECONFIG_PATH
                        export KUBECONFIG=$KUBECONFIG_PATH
                        kubectl apply -f k8s/frontend-deployment.yaml --validate=false
                        kubectl apply -f k8s/frontend-service.yaml --validate=false
                        """
                    }
                }
            }
        }
    }
}

