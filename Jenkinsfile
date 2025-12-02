pipeline {
    agent any

    environment {
        REGISTRY = "192.168.3.128:5001"
        IMAGE_NAME = "almalinux-jenkins"
        IMAGE_TAG = "14"
    }

    stages {
        stage('Checkout SCM') {
            steps {
                git url: 'https://github.com/gianmarcodauria/formazione_cm', branch: 'main'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    docker.build("${REGISTRY}/${IMAGE_NAME}:${IMAGE_TAG}", "-f dockerfiles/Dockerfile_almalinux dockerfiles")
                }
            }
        }

        stage('Tag Latest') {
            steps {
                script {
                    sh "docker tag ${REGISTRY}/${IMAGE_NAME}:${IMAGE_TAG} ${REGISTRY}/${IMAGE_NAME}:latest"
                }
            }
        }

        stage('Push to Registry') {
            steps {
                script {
                    // Non serve login perché il registry è locale e senza auth
                    sh "docker push ${REGISTRY}/${IMAGE_NAME}:${IMAGE_TAG}"
                    sh "docker push ${REGISTRY}/${IMAGE_NAME}:latest"
                }
            }
        }
    }

    post {
        always {
            echo 'Pulizia locale Docker'
            sh 'docker system prune -f'
        }

        success {
            echo 'Pipeline completata con successo!'
        }

        failure {
            echo 'Pipeline fallita!'
        }
    }
}

