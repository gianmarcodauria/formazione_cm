pipeline {
    agent any  // usa il master dove Docker è disponibile

    environment {
        REGISTRY = "192.168.3.128:5001"
        IMAGE_NAME = "almalinux-jenkins"
        DOCKERFILE_PATH = "dockerfiles/Dockerfile_almalinux"
        CONTEXT_PATH = "dockerfiles"
    }

    stages {
        stage('Checkout SCM') {
            steps {
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    def buildNumber = env.BUILD_NUMBER
                    // Costruisce l'immagine specificando Dockerfile non standard
                    dockerImage = docker.build("${REGISTRY}/${IMAGE_NAME}:${buildNumber}", 
                                               "-f ${DOCKERFILE_PATH} ${CONTEXT_PATH}")
                }
            }
        }

        stage('Tag Latest') {
            steps {
                script {
                    dockerImage.tag("${REGISTRY}/${IMAGE_NAME}:latest")
                }
            }
        }

        stage('Login and Push') {
            steps {
                script {
                    // Login al registry locale (modifica user/pass se necessario)
                    sh "docker login ${REGISTRY} -u admin -p admin"
                    dockerImage.push()
                    dockerImage.push("latest")
                }
            }
        }
    }

    post {
        always {
            echo "Pulizia locale Docker"
            sh "docker system prune -f"
        }
        success {
            echo "Pipeline completata con successo!"
        }
        failure {
            echo "Pipeline fallita!"
        }
    }
}

