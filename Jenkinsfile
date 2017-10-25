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
        junit 'report.xml'
        archiveArtifacts 'report.*' // hercules outputs xml and html reports
      }
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
      sh 'docker run -i --rm -v $PWD:/src -w /src alpine/git clean -fxd'
      deleteDir()  // clear workspace, for next run
    }
    failure {
      slackSend(color: 'danger', message: "${env.JOB_NAME} #${env.BUILD_NUMBER} FAILURE (<${env.BUILD_URL}|Open>)")
    }
    unstable {
      slackSend(color: 'warning', message: "${env.JOB_NAME} #${env.BUILD_NUMBER} UNSTABLE (<${env.BUILD_URL}|Open>)")
    }
  }
}
