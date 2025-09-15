pipeline {
    agent {
        docker {
            image 'node:18' // Use Node.js 18 official image
            args '-u root' // Run as root so you can install stuff if needed
        }
    }

    environment {
        IMAGE_NAME = 'keanghor13/react-landing-page-template'
        REGISTRY = 'docker.io'
        DOCKERHUB_CREDENTIALS_ID = 'dockerhub-creds'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Install Dependencies') {
            steps {
                sh 'npm ci'
            }
        }

        stage('Build React App') {
            steps {
                sh 'npm run build'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    def shortCommit = sh(script: "git rev-parse --short HEAD", returnStdout: true).trim()
                    env.IMAGE_TAG = "${shortCommit}"
                    env.FULL_IMAGE_NAME = "${IMAGE_NAME}:${IMAGE_TAG}"

                    echo "🔨 Building Docker image: ${FULL_IMAGE_NAME}"
                    sh "docker build -t ${FULL_IMAGE_NAME} ."
                    sh "docker tag ${FULL_IMAGE_NAME} ${IMAGE_NAME}:latest"
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                withCredentials([usernamePassword(credentialsId: "${DOCKERHUB_CREDENTIALS_ID}", usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh 'echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin'
                    sh "docker push ${FULL_IMAGE_NAME}"
                    sh "docker push ${IMAGE_NAME}:latest"
                    sh 'docker logout'
                }
            }
        }
    }

    post {
        success {
            echo "✅ Build and Docker image push completed!"
        }
        failure {
            echo "❌ Build failed. Check logs above."
        }
    }
}
