node {
     stage('CHECKOUT') {
        checkout scm
        sh "git rev-parse HEAD > .git/commit-id"
        def commit_id = readFile('.git/commit-id').trim()
        println commit_id
     }
     
     stage("BUILD") {
        checkout scm
        def commit_id = readFile('.git/commit-id').trim()
        sh "docker build -t hayitsbacon/bacon.lol:${commit_id} ."
     }
     
     stage("PUBLISH") {
         def commit_id = readFile('.git/commit-id').trim()
         sh "docker tag hayitsbacon/bacon.lol:${commit_id} hayitsbacon/bacon.lol:latest"
         withCredentials([usernamePassword(credentialsId: 'docker-hub-credentials', usernameVariable: 'HUB_USERNAME', passwordVariable: 'HUB_PASSWORD')]) {
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
            }
     }
}
