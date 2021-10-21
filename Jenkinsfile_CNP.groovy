#!groovy
//noinspection GroovyUnusedAssignment
@Library("Infrastructure") _

withInfraPipeline('vh') {
    enableSlackNotifications('#vh-builds')
}