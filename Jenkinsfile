node {
     stage('CHECKOUT') {
        sh "git checkout master && git reset --hard HEAD && git pull"
        sh "git rev-parse HEAD > .git/commit-id"
        def commit_id = readFile('.git/commit-id').trim()
        println commit_id
     }
     
     stage("BUILD") {
        sh "docker build -t hayitsbacon/bacon.lol:build ."
     }
     
     stage("PUBLISH") {
         withCredentials([usernamePassword(credentialsId: 'docker-hub-credentials', usernameVariable: 'HUB_USERNAME', passwordVariable: 'HUB_PASSWORD')]) {
            def commit_id = readFile('.git/commit-id').trim()
            sh "docker tag hayitsbacon/bacon.lol:build hayitsbacon/bacon.lol:${commit_id}"
            sh "docker login --username=$HUB_USERNAME --password=$HUB_PASSWORD"
            sh "docker push hayitsbacon/bacon.lol:latest && echo 'PUBLISH success'"
         }
     }
     stage("DEPLOY") {
            sshagent (credentials: ['baconlol-ec2']) {
                sh script: """\
                              ssh -o StrictHostKeyChecking=no -l ec2-user bacon.lol /bin/bash << EOF 
                              docker pull hayitsbacon/bacon.lol:latest 
                              echo 'Pulled container'
                              docker kill bacon-lol-nginx
                              docker rm bacon-lol-nginx
                              echo 'Removed old container'
                              docker run -d -p 80 -l traefik.frontend.rule=Host:bacon.lol --name=bacon-lol-nginx hayitsbacon/bacon.lol:latest
                              echo 'Run container'
EOF
                            """, returnStdout: false
                 sh "echo "DEPLOY Success"
            }
     }
}
