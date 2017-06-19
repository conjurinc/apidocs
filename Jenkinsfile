node('executor-v2') {

    stage 'Checkout'
    checkout scm

    stage 'Build'
    sh './jenkins.sh'

    stage 'Collect Results'
    step([$class: 'JUnitResultArchiver', testResults: 'report.xml'])
    archive 'report.html'

    if (env.BRANCH_NAME == 'master') {
      stage 'Publish'
      sh './publish.sh'
    }
}
