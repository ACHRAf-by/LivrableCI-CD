pipeline {
    agent any

	environment {
		def pip = "C:/Users/abenyahya/scoop/apps/python/current/Scripts/pip" 
		def python = "C:/Users/abenyahya/scoop/apps/python/current/python"
		DOCKERHUB_CREDENTIALS = credentials('dockerhub-credentials')
	}

	stages {
		stage('Clone from github') {
		    steps {
			dir("LivrableCICD") {
			    echo 'clone git repo'
			    git branch: 'dev',
			    credentialsId: 'jenkins-deploy-key',
			    url: 'git@github.com:ACHRAf-by/LivrableCI-CD.git'
			    bat 'dir'
			}
		    }
		}
		stage('Create staging branch and push') {
			steps {
				script {
					echo "Creating staging branch from dev branch"
					//SSH private key authentication using ssh step from the ssh-agent plugin
					sshagent(credentials: ['github-auth-key']){
						bat '''
						if exist .git/refs/heads/staging (
							git checkout main
							git branch -D staging
						)
						'''
						bat 'git checkout dev'
						bat 'git checkout -b staging'
						bat 'git push origin staging'
					}
					
					// I tried this before fixing the ssh-agent problem 
					// credentialsId here is the credentials you have set up in Jenkins for pushing
					// to that repository using username and password.
					//withCredentials([usernamePassword(credentialsId: 'github-auth', usernameVariable: 'GITHUB_USERNAME', passwordVariable: 'GITHUB_PASSWORD')]) {
						//bat 'git push origin staging'
					//}
                		}
            		}
        	}
        	stage('build from github') {
			steps {
				dir("LivrableCICD") {
					echo "pip install -r requirements.txt"
					bat "${pip} install -r requirements.txt"
				}
			}
		}
		stage('test from github') {
			steps {
				dir("LivrableCICD") {
					echo "pyhton -m unittest"
					bat "${python} -m unittest"
				}
			}
		}
		stage('deploying from github') {
			steps {
				dir("LivrableCICD") {
					echo "docker"
					//echo "Stop running container using the image name to free the port"
					//powershell 'docker rm $(docker stop $(docker ps -a -q --filter ancestor=abenyahya98/app --format="{{.ID}}"))'
					echo "Build image"
					bat 'docker image build -t abenyahya98/app .'
					echo "Run image"
					bat 'docker run -dp 5001:5000  --name ci_cd_container abenyahya98/app'
				}
			}
		}	
		stage('Logging into dockerhub') {
			steps {
				echo "Logging into dockerhub"
				bat "docker login -u=${DOCKERHUB_CREDENTIALS_USR} -p=${DOCKERHUB_CREDENTIALS_PSW}"
			}
		}
        
        	stage('Pushing image to dockerhub') {
			steps {
				echo "Pushing Image to dockerhub"
				bat 'docker push abenyahya98/app:latest'
			}
		}
		stage('Delete remote branch') {
			steps {
				echo "deleted staging"
				sshagent(credentials: ['github-sshagent']){
					bat 'git push origin -D staging'
				}
			}
		}
	}
    	
	post {
		always {
			echo "Post script steps"
			bat 'docker logout'
			
			// Stop and remove container
            		bat 'docker stop ci_cd_container'
            		bat 'docker rm ci_cd_container'

            		// Remove unused images, dangling images and volume 
            		bat 'docker image prune -af'
           		bat 'docker volume prune -f'
		}
	}
}
