pipeline {
  agent {
    kubernetes {
      yaml """
apiVersion: v1
kind: Pod
spec:
  containers:
    - name: node
      image: node:18-alpine
      command: [ "cat" ]
      tty: true
"""
    }
  }

  stages {
    stage('Install Dependencies') {
      steps {
        container('node') {
          sh 'npm install'
        }
      }
    }

    stage('Build') {
      steps {
        container('node') {
          // Unset CI so warnings don't fail the build
          sh 'CI= npm run build'
        }
      }
    }
  }
}
