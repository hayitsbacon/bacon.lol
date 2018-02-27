node {
     stage('CHECKOUT') {
        checkout scm 
        sh "git rev-parse HEAD > .git/commit-id"
        def commit_id = readFile('.git/commit-id').trim()
        println commit_id
     }
     
     stage("BUILD") {
        def app = docker.build "hayitsbacon/bacon.lol:build"
     }
     
     stage("PUBLISH") {
         withCredentials([usernamePassword(credentialsId: 'docker-hub-credentials', usernameVariable: 'HUB_USERNAME', passwordVariable: 'HUB_PASSWORD')]) {
            def commit_id = readFile('.git/commit-id').trim()
            sh "docker tag hayitsbacon/bacon.lol:build hayitsbacon/bacon.lol:${commit_id}"
            sh "docker login --username=$HUB_USERNAME --password=$HUB_PASSWORD"
            sh "docker push hayitsbacon/bacon.lol:${commit_id}"
            sh "docker push hayitsbacon/bacon.lol:latest && echo 'Push success'"
         }
     }
     stage("DEPLOY") {
            sshagent (credentials: ['baconlol-ec2']) {
                sh script: """\
                              ssh -o StrictHostKeyChecking=no -l ec2-user bacon.lol \
                              'docker pull hayitsbacon/bacon.lol:latest' \
                              && echo 'Pulled image'
                            """, returnStdout: true
                sh script: """\
                              ssh -o StrictHostKeyChecking=no -l ec2-user bacon.lol \
                              'docker run -d -p 80 -l traefik.frontend.rule=Host:bacon.lol hayitsbacon/bacon.lol:latest' \
                              && echo 'Ran image'
                            """, returnStdout: true
            }
     }
}
