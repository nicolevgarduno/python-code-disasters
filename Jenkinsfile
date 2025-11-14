pipeline {
    agent {
        kubernetes {
            label 'jenkins-agent'
            defaultContainer 'jnlp'
            yaml """
apiVersion: v1
kind: Pod
metadata:
  labels:
    some-label: jenkins-agent
spec:
  containers:
  - name: jnlp
    image: jenkins/inbound-agent:3345.v03dee9b_f88fc-6
    resources:
      limits:
        memory: "512Mi"
        cpu: "512m"
      requests:
        memory: "512Mi"
        cpu: "512m"
    workingDir: /home/jenkins/agent
"""
        }
    }

    environment {
        SONARQUBE_TOKEN = credentials('sonarqube-token') // replace with your Jenkins credential ID
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
                withSonarQubeEnv('SonarQube') { // 'SonarQube' is the name of your Jenkins SonarQube server
                    sh "sonar-scanner -Dsonar.login=${SONARQUBE_TOKEN}"
                }
            }
        }

        stage('Quality Gate') {
            steps {
                timeout(time: 5, unit: 'MINUTES') { // Wait max 5 min for SonarQube
                    waitForQualityGate abortPipeline: true
                }
            }
        }

        stage('Run Hadoop Job') {
            when {
                expression {
                    // Only run if Quality Gate passed
                    return currentBuild.result == null || currentBuild.result == 'SUCCESS'
                }
            }
            steps {
                echo "Running Hadoop MapReduce job..."
                sh '''
                    # Example Hadoop commands
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