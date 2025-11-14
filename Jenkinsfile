

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
                echo "Running SonarScanner in Docker..."
                sh """
                    docker run --rm \
                      -e SONAR_HOST_URL=http://136.107.36.122:9000 \
                      -e SONAR_LOGIN=$sqp_c51043e7daa4a1b9fcbc92c9abb120472e90b829 \
                      -v \$PWD:/usr/src \
                      sonarsource/sonar-scanner-cli:latest
                """
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
                    currentBuild.result == null || currentBuild.result == 'SUCCESS'
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
            echo "Pipeline finished. Check logs."
        }
        success {
            echo "Pipeline SUCCESS!"
        }
        failure {
            echo "Pipeline FAILED."
        }
    }
}
