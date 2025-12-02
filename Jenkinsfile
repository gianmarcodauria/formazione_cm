pipeline {
    agent any  // tutto gira sul master

    environment {
        REGISTRY = "192.168.3.128:5001"   // registry locale
        IMAGE_NAME = "almalinux-jenkins"  // nome immagine
        CREDS = "registry-creds"          // ID credenziali Jenkins
        DOCKERFILE_PATH = "/var/jenkins_home/dockerfiles/Dockerfile"
        CONTEXT_PATH = "/var/jenkins_home/dockerfiles"
    }

    stages {
        stage('Build Docker Image') {
            steps {
                script {
                    def buildNumber = env.BUILD_NUMBER
                    // build immagine usando il Dockerfile corretto
                    dockerImage = docker.build(
                        "${REGISTRY}/${IMAGE_NAME}:${buildNumber}", 
                        "${CONTEXT_PATH} -f ${DOCKERFILE_PATH}"
                    )
                }
            }
        }

        stage('Tag Latest') {
            steps {
                script {
                    sh """
                        docker tag ${REGISTRY}/${IMAGE_NAME}:${BUILD_NUMBER} \
                                   ${REGISTRY}/${IMAGE_NAME}:latest
                    """
                }
            }
        }

        stage('Login and Push') {
            steps {
                script {
                    docker.withRegistry("http://${REGISTRY}", CREDS) {
                        dockerImage.push()
                        dockerImage.push("latest")
                    }
                }
            }
        }
    }

    post {
        always {
            echo "Pulizia locale Docker"
            sh "docker system prune -f"
        }
    }
}

