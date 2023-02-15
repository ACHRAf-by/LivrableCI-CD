pipeline {
    agent any
    
    
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
                    if exist .git\refs\heads\staging (
                        git checkout main
                        git branch -D staging
                    )
                    '''
                    bat "git checkout dev"
                    bat "git checkout -b staging"
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
                    powershell 'docker rm $(docker stop $(docker ps -a -q --filter ancestor=app --format="{{.ID}}"))'
                    echo "Build image"
                    bat 'docker build -t app .'
                    echo "Run image"
                    bat 'docker run -dp 5001:5000 app'
                }
            }
        }
    }
}
