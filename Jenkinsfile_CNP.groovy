#!groovy
//noinspection GroovyUnusedAssignment
@Library("Infrastructure") _

withInfraPipeline('pre') {
    enableSlackNotifications('#vh-builds')
}