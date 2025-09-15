pipeline {
  agent any

  stages {
    stage('Install Dependencies') {
      steps {
        echo 'Installing npm dependencies...'
        sh 'npm ci'
      }
    }

    stage('Test') {
      steps {
        echo 'Running tests...'
        sh 'npm test'
      }
    }

    stage('Build') {
      steps {
        echo 'Building the React app...'
        sh 'npm run build'
      }
    }

    stage('Deploy (Simulated)') {
      steps {
        echo 'Deploy stage - add your deploy steps here'
        // For now, just echo deploy success
        sh 'echo "Deploy step completed (simulate deploy)"'
      }
    }
  }

  post {
    success {
      echo 'Pipeline succeeded!'
    }
    failure {
      echo 'Pipeline failed!'
    }
  }
}
