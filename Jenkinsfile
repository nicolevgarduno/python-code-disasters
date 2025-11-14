pipeline {
    agent any

    environment {
        SONARQUBE_TOKEN = credentials('sonarqube-token')
        SONAR_HOST = "http://136.107.36.122:9000"
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
                sh '''
                    echo "[INFO] Downloading SonarScanner..."
                    curl -L -o sonar.zip https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-5.0.1.3006-linux.zip
                    unzip -o sonar.zip
                    rm sonar.zip

                    echo "[INFO] Running SonarScanner..."
                    ./sonar-scanner-5.0.1.3006-linux/bin/sonar-scanner \
                        -Dsonar.projectKey=python-code-disasters \
                        -Dsonar.sources=. \
                        -Dsonar.host.url=$SONAR_HOST \
                        -Dsonar.login=$SONARQUBE_TOKEN
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
            steps {
                echo "Running Hadoop job..."
                sh '''
                    hadoop fs -put -f . /user/jenkins/input/
                    hadoop jar /opt/hadoop/share/hadoop/mapreduce/hadoop-mapreduce-examples-*.jar \
                        wordcount /user/jenkins/input /user/jenkins/output
                    hadoop fs -cat /user/jenkins/output/part-r-00000
                '''
            }
        }
    }
}
