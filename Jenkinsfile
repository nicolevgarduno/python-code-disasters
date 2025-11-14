pipeline {
    agent any

    environment {
        SONARQUBE_TOKEN = credentials('sonarqube-token')
        SONAR_HOST_URL = 'http://136.107.36.122:9000'
    }

    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'master',
                    url: 'https://github.com/nicolevgarduno/python-code-disasters.git'
            }
        }

        stage('Install & Run SonarScanner') {
            steps {
                sh '''
                    echo "Downloading SonarScanner CLI..."
                    curl -o scanner.zip https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-5.0.1.3006-linux.zip

                    echo "Unzipping..."
                    unzip -o scanner.zip

                    echo "Running SonarScanner..."
                    ./sonar-scanner-5.0.1.3006-linux/bin/sonar-scanner \
                      -Dsonar.projectKey=python-code-disasters \
                      -Dsonar.sources=. \
                      -Dsonar.host.url=$SONAR_HOST_URL \
                      -Dsonar.token=$SONARQUBE_TOKEN

                '''
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
                expression {
                    return currentBuild.result == null || currentBuild.result == 'SUCCESS'
                }
            }
            steps {
                echo "Running Hadoop MapReduce job..."
                sh '''
                    hadoop fs -put -f ./* /user/jenkins/input/
                    hadoop jar /opt/hadoop/share/hadoop/mapreduce/hadoop-mapreduce-examples-*.jar wordcount /user/jenkins/input /user/jenkins/output
                    hadoop fs -cat /user/jenkins/output/part-r-00000
                '''
            }
        }
    }

    post {
        always {
            echo "Pipeline finished."
        }
        success {
            echo "Pipeline completed successfully!"
        }
        failure {
            echo "Pipeline failed."
        }
    }
}
