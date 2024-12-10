pipeline {
    agent any
    environment {
        DOCKER_IMAGE = 'yashjskj/backend:latest'
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
                    sh 'kubectl apply -f k8s/namespace.yaml'
                    sh 'kubectl apply -f k8s/frontend-deployment.yaml'
                    sh 'kubectl apply -f k8s/frontend-service.yaml'
                    
                    // Rollout restart to apply the new deployment
                    sh 'kubectl rollout restart deployment/frontend -n frontend'

                     // Adding sleep for 40 seconds
                    echo 'Waiting for 40 seconds to ensure service are running...'
                    sleep 40

                    // Verify if the frontend pod is running
                    def frontendPodStatus = sh(script: 'kubectl get pods -n frontend -l app=frontend -o jsonpath="{.items[0].status.phase}"', returnStdout: true).trim()
                    if (frontendPodStatus != 'Running') {
                        echo "Frontend pod is not running, initiating rollback..."
                        // Rollback frontend deployment if it's not running
                        sh 'kubectl rollout undo deployment/frontend -n frontend'
                        currentBuild.result = 'FAILURE' // Mark the build as failed
                    }
                }
            }
        }
    }
}
