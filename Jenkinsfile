pipeline {
  agent any

  stages {
    stage('Install Dependencies') {
      steps {
        sh 'npm install'
      }
    }

    stage('Build') {
      steps {
        // Unset CI so warnings don't fail the build
        sh 'CI= npm run build'
      }
    }
  }
}
