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
   sh "docker push hayitsbacon/bacon.lol"
   app.push 'latest'
   app.push "${commit_id}"

}
