pipeline {
    agent any
    environment {
        HARBOR_ADDR = "192.168.10.10"
        HARBOR_PROJECT = "cicd"
        IMAGE_NAME = "java-demo"
        IMAGE_TAG = "${BUILD_NUMBER}"
    }
    stages {
        stage('Maven Build') {
            steps { sh 'mvn clean package -DskipTests' }
        }
        stage('Build Image') {
            steps { sh "docker build -t ${HARBOR_ADDR}/${HARBOR_PROJECT}/${IMAGE_NAME}:${IMAGE_TAG} ." }
        }
        stage('Push Harbor') {
            steps { sh "docker push ${HARBOR_ADDR}/${HARBOR_PROJECT}/${IMAGE_NAME}:${IMAGE_TAG}" }
        }
        stage('Deploy K8s') {
            steps {
                sh "kubectl apply -f k8s/app.yaml"
                sh "kubectl set image deploy/java-demo java-demo=${HARBOR_ADDR}/${HARBOR_PROJECT}/${IMAGE_NAME}:${IMAGE_TAG} -n default"
            }
        }
    }
}
