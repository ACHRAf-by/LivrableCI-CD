pipeline {
    agent any
    
    environment {
        
        DOCKERHUB_CREDENTIALS = credentials('dockerhub') 
        SSH_CREDENTIALS = credentials('ssh-credentials')

    }
    
    stages {
        stage('Clone from github'){
            steps{
                dir("LivrableCICD"){
                    echo 'clone git repo'
                    git branch: 'dev', credentialsId: 'jenkins', url: 'git@github.com:ACHRAf-by/LivrableCI-CD.git'
                    bat 'dir'
                }
            }
        }
        
        stage('Create staging branch'){
            steps {
                dir("LivrableCICD"){
                    echo "Creating staging branch from dev branch"
                    bat '''
                    if exist .git/refs/heads/staging (
                        git checkout main
                        git branch -D staging
                    )
                    '''
                    bat "git checkout dev"
                    bat "git checkout -b staging"

                    // SSH private key authentication using ssh step from the ssh-agent plugin
                    //sshagent(credentials: ['github-sshagent']){
                    //    bat 'git push --set-upstream origin staging'
                    //}
                    
                    // credentialsId here is the credentials you have set up in Jenkins for pushing
                    // to that repository using username and password.
                    //withCredentials([usernamePassword(credentialsId: 'github-auth', usernameVariable: 'GITHUB_USERNAME', passwordVariable: 'GITHUB_PASSWORD')]) {
                        //bat 'git push --set-upstream origin staging'
                    //} 
                    
                    bat '''
                        git config --global core.sshCommand "ssh -i %SSH_CREDENTIALS%"
                        ssh-agent cmd /c "ssh-add %SSH_CREDENTIALS% && git push --set-upstream origin staging"
                    '''
                }
            }
        }
        
        stage('build from github') {
            steps {
                dir("LivrableCICD"){
                    echo "pip install -r requirements.txt"
                    bat 'pip install -r requirements.txt'
                }
            }
        }
        stage('test from github') {
            steps {
                dir("LivrableCICD"){
                    echo "pyhton -m unittest"
                    bat 'python -m unittest'
                }
            }
        }
        
        stage('deploying from github'){
           
            steps{
                dir("LivrableCICD"){
                    echo "docker"
                    echo "Stop running container using the image name to free the port"
                    powershell 'docker rm $(docker stop $(docker ps -a -q --filter ancestor=abenyahya98/app --format="{{.ID}}"))'
                    echo "Build image"
                    bat 'docker build -t abenyahya98/app .'
                    echo "Run image"
                    bat 'docker run -dp 5001:5000 abenyahya98/app'
                }
            }
        }
        
        stage('logging into dockerhub') {
            steps {
                bat "docker login -u=${DOCKERHUB_CREDENTIALS_USR} -p=${DOCKERHUB_CREDENTIALS_PSW}"
            }
        }
        
        stage('pushing image to dockerhub') {
            steps {
                bat 'docker push abenyahya98/app:latest'
            }
        }
    }
    post {
        always {
            bat 'docker logout'
            //sshagent(credentials: ['github-sshagent']){
                //bat 'git push origin -D staging'
            //}
            echo "deleted staging"
            //stage('Cleanup') {
                //steps {
                    // Stop and remove container
                    //sh 'docker stop my-container'
                    //sh 'docker rm my-container'
                    // Remove unused images and volumes
                    //sh 'docker image prune -af'
                    //sh 'docker volume prune -f'
                 }
            }
    }
