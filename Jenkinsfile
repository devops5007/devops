pipeline {
    agent any
    stages {
        stage ('Initialize') {
            steps {
                sh '''
                    echo "PATH = ${PATH}"
                    echo "M2_HOME = ${M2_HOME}"
                '''
            }
        }

        stage ('Build') {
            steps {
                sh 'mvn clean install -DskipTests'
            }
            
        }

         stage('Build docker image') {
            steps {
                sh "docker build -t ${env.REPOSITORY_URI}:${env.BRANCH_NAME}_${env.BUILD_NUMBER} ."

            }
        }

        stage('Push Docker Image') {
            steps {
                echo 'Logging into Amazon ECR...'
                //withDockerRegistry(credentialsId: 'ecr:eu-central-1:ecs-ecr_id', url: 'https://7234409129207.dkr.ecr.eu-west-2.amazonaws.com/test-repository') {
                    sh "docker push ${env.REPOSITORY_URI}:${env.BRANCH_NAME}_${env.BUILD_NUMBER}"
              //  } 
            }
       }

       /*	stage ('Deploy to dev stack') {
			steps {
					script {
						if (env.BRANCH_NAME == "development") {
							withEnv(['CFN_STACK=Initial-stack-ECS']) {
								echo env.CFN_STACK
								sh """sed -e "s;%FRONTENDIMAGE_VERSION%;${BRANCH_NAME}_${BUILD_NUMBER};g" ./cfn-templates/QA_cfn_parameters.json > parameters.json"""
								sh 'chmod +x deploy.sh'
								sh './deploy.sh'
							}
						} 
						else {
							echo 'No match for deployment candidate'
						}
					}
			}	
		}*/

    }
    tools {
        maven 'Maven 3.6.3'
        jdk 'jdk8'
    }
    post {
        success {
            junit testResults: 'target/reports/**/*.xml', allowEmptyResults: true
                }
        }
}