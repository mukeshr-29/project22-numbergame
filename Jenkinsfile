pipeline{
    agent any
    tools{
        jdk 'jdk-17'
        nodejs 'node-16'
    }
    environment{
        SCANNER_HOME=tool 'sonar-scanner'
    }
    stages{
        stage('clean workspace'){
            steps{
                cleanWs()
            }
        }
        stage('gitcheckout'){
            steps{
                git 'https://github.com/mukeshr-29/project22-numbergame.git'
            }
        }
        stage('sonarqube analysis'){
            steps{
                script{
                    withSonarQubeEnv(credentialsId: 'sonarqube', installationName: 'sonar-server'){
                        sh '''
                            $SCANNER_HOME/bin/sonar-scanner -Dsonar.projectKey=number_game -Dsonar.projectName=number_game
                        '''
                    }
                }
            }
        }
        stage('qualitygate status check'){
            steps{
               script{
                    waitForQualityGate abortPipeline: false, credentialsId: 'sonarqube'
               } 
            }
        }
        stage('install dependencies'){
            steps{
                sh 'npm install'
            }
        }
        stage('dependency check'){
            steps{
                dependencyCheck additionalArguments: '--scan ./ --disableYarnAudit --disableNodeAudit', odcInstallation: 'dp-check'
                dependencyCheckPublisher pattern: '**/dependency-check-report.xml'
            }
        }
        stage('trivy file scan'){
            steps{
                sh 'trivy fs . > trivyfs.txt'
            }
        }
        stage('docker build and push'){
            steps{
                script{
                    withDockerRegistry(credentialsId: 'dockerhub', toolName: 'docker'){
                        sh '''
                            docker build -t mukeshr29/number-game:latest .
                            docker push mukeshr29/number-game:latest
                        '''
                    }
                }
            }
        }
        stage('trivy img scan'){
            steps{
                sh 'trivy image mukeshr29/number-game:latest > trivyimg.txt'
            }
        }
        stage('deploy to container'){
            steps{
                sh 'docker run -d -p 3000:3000 mukeshr29/number-game:latest'
            }
        }
        // stage('kubernetes deployment'){
        //     steps{
        //         script{

        //         }
        //     }
        // }
    }
}