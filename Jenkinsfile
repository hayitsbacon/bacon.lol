node("any") {
    docker.withRegistry('https://registry.hub.docker.com', 'docker-hub-credentials') {
         
        git url: "ssh://ec2-user@bacon.lol/~/bacon.lol", credentialsId: 'blueocean-folder-credential-domain'
        checkout scm 
        sh "git rev-parse HEAD > .git/commit-id"
        def commit_id = readFile('.git/commit-id').trim()
        println commit_id
    
        stage "build"
        def app = docker.build "hayitsbacon/bacon.lol"
    
        stage "publish"
        app.push 'latest'
        app.push "${commit_id}"
    }
}
