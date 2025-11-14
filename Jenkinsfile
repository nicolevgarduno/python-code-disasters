pipeline {
    agent any

    environment {
        SONARQUBE_TOKEN = credentials('sonarqube-token')
    }

    stages {

        stage('Checkout Code') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/nicolevgarduno/python-code-disasters.git'
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('SonarQube') {
                    sh """
                    docker run --rm \
                        -e SONAR_HOST_URL=$SONAR_HOST_URL \
                        -e SONAR_LOGIN=$SONARQUBE_TOKEN \
                        -v \$(pwd):/usr/src \
                        sonarsource/sonar-scanner-cli:latest
                    """
                }
            }
        }

        stage('Quality Gate') {
            steps {
                timeout(time: 5, unit: 'MINUTES') {
                    waitForQualityGate abortPipeline: true
                }
            }
        }

        stage('Run Hadoop Job') {
            when {
                expression { currentBuild.result == null || currentBuild.result == 'SUCCESS' }
            }
            steps {
                echo "Running Hadoop MapReduce job..."
                sh """
                echo 'fake hadoop job running'
                """
            }
        }
    }

    post {
        always { echo "Pipeline finished. Check logs for details." }
        success { echo "Pipeline completed successfully!" }
        failure { echo "Pipeline failed. See errors above." }
    }
}
