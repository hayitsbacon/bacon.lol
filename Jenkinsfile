node {
    docker.withRegistry('https://docker.io', 'docker-hub-credentials') {
         
        checkout scm 
        sh "git rev-parse HEAD > .git/commit-id"
        def commit_id = readFile('.git/commit-id').trim()
        println commit_id
    
        stage "build"
        def app = docker.build "hayitsbacon/bacon.lol"
    
        stage "publish"
        sh "docker push hayitsbacon/bacon.lol"
        app.push 'latest'
        app.push "${commit_id}"
    }
}
