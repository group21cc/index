pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "your-dockerhub-username/test-html"   // change this
        DOCKER_TAG = "latest"
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/group21cc/index.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh "docker build -t $DOCKER_IMAGE:$DOCKER_TAG ."
                }
            }
        }

        stage('Push to DockerHub') {
            steps {
                script {
                    withDockerRegistry([credentialsId: 'dockerhub-credentials', url: '']) {
                        sh "docker push $DOCKER_IMAGE:$DOCKER_TAG"
                    }
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                withCredentials([file(credentialsId: 'kubeconfig', variable: 'KUBECONFIG')]) {
                    script {
                        // Example deployment yaml
                        writeFile file: 'k8s-deployment.yaml', text: """
apiVersion: apps/v1
kind: Deployment
metadata:
  name: html-test
spec:
  replicas: 1
  selector:
    matchLabels:
      app: html-test
  template:
    metadata:
      labels:
        app: html-test
    spec:
      containers:
      - name: html-container
        image: $DOCKER_IMAGE:$DOCKER_TAG
        ports:
        - containerPort: 80
---
apiVersion: v1
kind: Service
metadata:
  name: html-service
spec:
  selector:
    app: html-test
  ports:
    - protocol: TCP
      port: 80
      targetPort: 80
  type: NodePort
"""
                        sh "kubectl apply -f k8s-deployment.yaml"
                    }
                }
            }
        }
    }
}
