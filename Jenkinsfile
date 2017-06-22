#!/usr/bin/env groovy

pipeline {
  agent { label 'executor-v2' }

  options {
    timestamps()
    buildDiscarder(logRotator(numToKeepStr: '30'))
  }

  stages {
    stage('Render api.md') {
      steps {
        sh 'make api.md'
        archive 'api.md'
      }
    }
  }

  post {
    always {
      deleteDir()  // clear workspace
    }
  }
}

// node('executor-v2') {
//
//     stage 'Checkout'
//     checkout scm
//
//     stage 'Build'
//     sh './jenkins.sh'
//
//     stage 'Collect Results'
//     step([$class: 'JUnitResultArchiver', testResults: 'report.xml'])
//     archive 'report.html'
//
//     if (env.BRANCH_NAME == 'master') {
//       stage 'Publish'
//       sh './publish.sh'
//     }
// }
