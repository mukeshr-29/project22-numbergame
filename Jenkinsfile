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
    }
}