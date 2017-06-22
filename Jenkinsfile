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
        archive artifacts: 'api.md', fingerprint: true
      }
    }
    stage('Run tests') {
      steps {
        sh './test.sh'
        junit 'report.xml'
      }
    }
    stage('Fix file perms') {  // TODO: this stage should be unnecessary
      steps {
        sh 'sudo chown -R jenkins:jenkins .'
      }
    }
  }

  post {
    always {
      deleteDir()  // clear workspace, for next run
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
