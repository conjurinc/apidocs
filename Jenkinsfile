node('executor') {
    git 'git@github.com:conjurinc/apidocs.git'

    stage 'Build'
    sh './jenkins.sh'

    stage 'Collect Results'
    step([$class: 'JUnitResultArchiver', testResults: 'report.xml'])
    archive 'report.html'
}
