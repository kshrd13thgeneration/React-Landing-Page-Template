pipeline {
    agent {
        kubernetes {
            yaml """
apiVersion: v1
kind: Pod
metadata:
  labels:
    some-label: react-build
spec:
  containers:
  - name: node
    image: node:18
    command:
    - cat
    tty: true
    volumeMounts:
    - name: workspace-volume
      mountPath: /home/jenkins/agent
  volumes:
  - name: workspace-volume
    emptyDir: {}
"""
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
                container('node') {
                    sh 'npm ci'
                }
            }
        }

        stage('Build React App') {
            steps {
                container('node') {
                    sh 'npm run build'
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                container('node') {
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
        }

        stage('Push Docker Image') {
            steps {
                container('node') {
                    withCredentials([usernamePassword(credentialsId: "${DOCKERHUB_CREDENTIALS_ID}", usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                        sh 'echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin'
                        sh "docker push ${FULL_IMAGE_NAME}"
                        sh "docker push ${IMAGE_NAME}:latest"
                        sh 'docker logout'
                    }
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
