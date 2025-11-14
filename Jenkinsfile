pipeline {
    agent any  // use any available Jenkins node with the tools installed

    environment {
        SONARQUBE_TOKEN = credentials('sonarqube-token') // your SonarQube credential
    }

    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'master',
                    url: 'https://github.com/nicolevgarduno/python-code-disasters.git'
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('SonarQube') {
                    sh "sonar-scanner -Dsonar.login=${SONARQUBE_TOKEN}"
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
                sh '''
                    hadoop fs -put -f ./python-code-disasters/* /user/jenkins/input/
                    hadoop jar /opt/hadoop/share/hadoop/mapreduce/hadoop-mapreduce-examples-*.jar wordcount /user/jenkins/input /user/jenkins/output
                    hadoop fs -cat /user/jenkins/output/part-r-00000
                '''
            }
        }
    }

    post {
        always {
            echo "Pipeline finished. Check logs for details."
        }
        success {
            echo "Pipeline completed successfully!"
        }
        failure {
            echo "Pipeline failed. See errors above."
        }
    }
}
