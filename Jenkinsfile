// pipeline {
//     agent any

//     environment {
//         // Define environment variables here if needed
//         DOCKER_IMAGE = "your-dockerhub-username/your-app:latest"
//     }

//     stages {
//         stage('Build') {
//             steps {
//                 echo 'Building the application...'
//                 // Example for Node.js:
//                 // sh 'npm install'
                
//                 // Example for Java:
//                 // sh './mvnw clean compile'

//                 // Docker example:
//                 sh 'docker build -t $DOCKER_IMAGE .'
//             }
//         }

//         stage('Test') {
//             steps {
//                 echo 'Running tests...'
//                 // Node.js
//                 // sh 'npm test'

//                 // Java
//                 // sh './mvnw test'

//                 // Placeholder
//                 sh 'echo "Running tests (simulate)"'
//             }
//         }

//         stage('Deploy') {
//             steps {
//                 echo 'Deploying application...'
                
//                 // Example: push Docker image to Docker Hub
//                 withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
//                     sh '''
//                         echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
//                         docker push $DOCKER_IMAGE
//                     '''
//                 }

//                 // You could also deploy to Kubernetes:
//                 // sh 'kubectl apply -f k8s/deployment.yaml'
//             }
//         }
//     }

//     post {
//         success {
//             echo 'Pipeline succeeded!'
//         }
//         failure {
//             echo 'Pipeline failed!'
//         }
//     }
// }


pipeline {
    agent any

    tools {
        nodejs 'NodeJS 18' // Must match the name in Jenkins Global Tool Config
    }

    environment {
        IMAGE_NAME = 'keanghor13/react-landing-page-template' // ✅ your actual image name
        REGISTRY = 'docker.io'
        DOCKERHUB_CREDENTIALS_ID = 'dockerhub-creds' // ✅ you must set this in Jenkins
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

                    echo "🏷️  Tagging as latest"
                    sh "docker tag ${FULL_IMAGE_NAME} ${IMAGE_NAME}:latest"
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                withCredentials([usernamePassword(credentialsId: "${DOCKERHUB_CREDENTIALS_ID}", usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    echo "🔐 Logging in to Docker Hub..."
                    sh 'echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin'

                    echo "📤 Pushing Docker image..."
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
