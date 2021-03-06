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
        archiveArtifacts artifacts: 'api.md', fingerprint: true
      }
    }
    stage('Run tests') {
      steps {
        sh './test.sh'
      }
      post { always {
        junit 'report.xml'
        archiveArtifacts 'report.*' // hercules outputs xml and html reports
      }}
    }
    stage('Publish') {
      when {
        branch 'master'
      }
      steps {
        sh './publish.sh'
      }
    }
  }

  post {
    always {
      cleanupAndNotify(currentBuild.currentResult)
    }
  }
}
