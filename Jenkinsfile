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
        sh '''docker login --username=$HUB_USERNAME --password=$HUB_PASSWORD && 
              docker push hayitsbacon/bacon.lol:${commit_id} &&
              docker push hayitsbacon/bacon.lol:latest'''
        
     
     }
}
}
