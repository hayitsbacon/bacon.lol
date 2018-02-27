node {
     stage('CHECKOUT') {
        checkout scm 
        sh "git rev-parse HEAD > .git/commit-id"
        def commit_id = readFile('.git/commit-id').trim()
        println commit_id
     }
     
     stage("BUILD") {
        def app = docker.build "hayitsbacon/bacon.lol"
     }
     
     stage("PUBLISH") {
     withCredentials([usernamePassword(credentialsId: 'docker-hub-credentials', usernameVariable: 'HUB_USERNAME', passwordVariable: 'HUB_PASSWORD')]) {
        def commit_id = readFile('.git/commit-id').trim()
        sh "docker login --username=$HUB_USERNAME --password=$HUB_PASSWORD"
        sh "docker push hayitsbacon/bacon.lol:${commit_id} && echo 'Push success'"
     }
}
}
