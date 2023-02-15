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
                    bat 'docker build -t app .'
                    bat 'docker run -dp 5001:5000 app'
                    bat 'FOR /f "tokens=*" %i IN (\'docker ps -a -q --filter "ancestor=app"\') DO docker stop %i'
                }
            }
        }
    }
}
