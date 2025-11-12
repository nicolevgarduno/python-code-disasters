pipeline {
    agent any

    environment {
        SONAR_TOKEN = credentials('sonaqube-token-2') // Use your Jenkins SonarQube token
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'master', url: 'https://github.com/nicolevgarduno/python-code-disasters.git'
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('MySonarServer') {
                    script {
                        def scannerHome = tool 'SonarScanner'
                        sh "${scannerHome}/bin/sonar-scanner \
                            -Dsonar.projectKey=CodeDisasters \
                            -Dsonar.sources=. \
                            -Dsonar.host.url=http://34.85.168.25 \
                            -Dsonar.login=${SONAR_TOKEN}"
                    }
                }
            }
        }
        stage('Check Quality Gate') {
            steps {
                script {
                    timeout(time: 10, unit: 'MINUTES') {
                        def qg = waitForQualityGate()
                        if (qg.status != 'OK') {
                            error "Quality Gate failed: ${qg.status}"
                        }
                    }
                }
            }
        }
/*
        stage('Run Hadoop Job') {
            steps {
                script {
                    // Replace with your Hadoop command
                    sh "hadoop jar /path/to/hadoop-job.jar YourMainClass /input /output"
                }
            }
        }

        stage('Display Results') {
            steps {
                sh "hdfs dfs -cat /output/*"
            }
        }
*/
    }
    
    post {
        always {
            echo "Pipeline finished"
        }
    }
}
