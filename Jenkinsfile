pipeline {
    agent any

    environment {
        def pip = "C:/Users/Achraf/AppData/Local/Programs/Python/Python39-32/Scripts/pip"
        def python = "C:/Users/Achraf/AppData/Local/Programs/Python/Python39-32/python"
    }

    stages {
        stage('clone from github'){
            steps{
                dir("CI_with_github"){
                    echo 'clone git repo'
                    git branch: 'develop', credentialsId: 'jenkins', url: 'git@github.com:ACHRAf-by/LivrableCI-CD.git'
                    bat 'dir'
                }
            }
        }
        stage('build from github') {
            steps {
                dir("CI_with_github"){
                    echo 'pip install -r requirements.txt'
                    bat "${pip} install -r requirements.txt"
                }
            }
        }
        stage('test from github') {
            steps {
                dir("CI_with_github"){
                    echo "pyhton -m unittest"
                    bat "${python} -m unittest"
                }
            }
        }
        stage('deploying from github'){
            steps{
                dir("CI_with_github"){
                    echo "docker"
                    bat 'docker build -t app .'
                    bat 'docker run -dp 5001:5000 app'
                }
            }
        }
    }
}
