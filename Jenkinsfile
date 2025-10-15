pipeline {
    agent any

    environment {
        REGISTRY = 'nexus-host:8082'                    // Replace with your Nexus host
        IMAGE_NAME = 'gopalh18/index'                   // Replace with your Nexus repo/image
        IMAGE_TAG = "v1.${BUILD_NUMBER}"
        FULL_IMAGE = "${REGISTRY}/${IMAGE_NAME}:${IMAGE_TAG}"
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                sh "docker build -t ${FULL_IMAGE} ."
            }
        }

        stage('Push to Nexus') {
            steps {
                script {
                    withDockerRegistry([credentialsId: 'nexus-creds', url: "http://${REGISTRY}"]) {
                        sh "docker push ${FULL_IMAGE}"
                    }
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                withCredentials([file(credentialsId: 'kubeconfig', variable: 'KUBECONFIG')]) {
                    script {
                        // Replace IMAGE_PLACEHOLDER in YAMLs and apply
                        sh """
                        sed 's|IMAGE_PLACEHOLDER|${FULL_IMAGE}|' index/dev.deployment.yaml > k8s-deploy.yaml
                        kubectl apply -f k8s-deploy.yaml
                        kubectl apply -f index/dev.service.yaml
                        """
                    }
                }
            }
        }
    }

    post {
        success {
            echo "✅ Deployment complete: ${FULL_IMAGE}"
        }
        failure {
            echo "❌ Something went wrong"
        }
    }
}
