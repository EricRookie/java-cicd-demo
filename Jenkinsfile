pipeline {
    agent any
    environment {
        // ====================== 你只改这里 ======================
        GIT_URL         = 'https://github.com/EricRookie/java-cicd-demo.git'
        ACR_REGISTRY    = 'registry.cn-beijing.aliyuncs.com'
        ACR_NAMESPACE   = 'pzyhub'
        IMAGE_NAME      = 'java-cicd-demo'
        IMAGE_TAG       = "v${BUILD_NUMBER}"
        namespace       = "cicd"
        // =======================================================
    }
    stages {
        stage('1. 拉代码') {
            steps {
               checkout scmGit(branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[credentialsId: 'ab9aa5ee-1b3b-47ea-9381-fd878e32e7d4', url: 'git@github.com:EricRookie/java-cicd-demo.git']])
            }
        }

        stage('2. Maven编译') {
            steps {
                sh 'mvn clean install'
            }
        }

        stage('3. 构建Docker镜像') {
            steps {
                sh "docker build -t ${ACR_REGISTRY}/${ACR_NAMESPACE}/${IMAGE_NAME}:${IMAGE_TAG} ."
            }
        }

        stage('4. 推送到阿里云ACR') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'aliyun-acr', 
                    usernameVariable: 'USER', 
                    passwordVariable: 'PWD'
                )]) {
                    sh "echo ${PWD} | docker login ${ACR_REGISTRY} -u ${USER} --password-stdin"
                    sh "docker push ${ACR_REGISTRY}/${ACR_NAMESPACE}/${IMAGE_NAME}:${IMAGE_TAG}"
                }
            }
        }

        stage('5. 发布到K8s') {
            steps {
                withCredentials([file(
                    credentialsId: 'kubeconfig', 
                    variable: 'KUBECONFIG'
                )]) {
                    sh "kubectl --kubeconfig ${KUBECONFIG} set image deployment/java-cicd-demo java-cicd-demo=${ACR_REGISTRY}/${ACR_NAMESPACE}/${IMAGE_NAME}:${IMAGE_TAG} -n ${namespace}"
                }
            }
        }
    }
}
