pipeline {
    agent {
        docker {
            image 'node:18-alpine'
            args '-u root:root' // Prevent permission issues (optional)
        }
    }

    environment {
        CI = 'true'  // Important for React build optimizations
    }

    stages {
        stage('Install dependencies') {
            steps {
                sh 'npm install'
            }
        }

        stage('Run tests') {
            steps {
                sh 'npm test -- --watchAll=false'
            }
        }

        stage('Build project') {
            steps {
                sh 'npm run build'
            }
        }

        stage('Archive build artifacts') {
            steps {
                archiveArtifacts artifacts: 'build/**', fingerprint: true
            }
        }
    }

    post {
        success {
            echo '✅ React build completed successfully!'
        }
        failure {
            echo '❌ Build failed.'
        }
        always {
            echo '📝 Build finished.'
        }
    }
}
