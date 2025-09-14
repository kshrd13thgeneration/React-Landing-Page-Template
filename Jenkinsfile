pipeline {
    agent any
    stages {
        stage('Build') {
            agent {
                docker { image 'node:18-alpine' }
            }
            steps {
                sh 'npm install'
                sh 'npm run build'
            }
        }
        stage('Deploy with Helm') {
            agent {
                docker { image 'lachlanevenson/k8s-helm:latest' }  // Official Helm image
            }
            steps {
                withCredentials([file(credentialsId: 'kubeconfig', variable: 'KUBECONFIG')]) {
                    sh 'helm repo update'
                    sh 'helm upgrade --install my-react-app ./helm-chart --namespace default'
                }
            }
        }
    }
}
