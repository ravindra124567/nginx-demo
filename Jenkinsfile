pipeline {
    agent any

    environment {
        IMAGE_NAME = "nginx-demo"
        DOCKERHUB_USER = "your_dockerhub_username"  // optional
    }

    stages {
        stage('Checkout') {
            steps {
                echo "Pulling code from GitHub..."
                git branch: 'main', url: 'https://github.com/yourusername/nginx-demo.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                echo "Building Docker image..."
                sh "docker build -t ${IMAGE_NAME}:latest ."
            }
        }

        stage('Run Container') {
            steps {
                echo "Running container on port 8080..."
                sh '''
                docker stop nginx-demo || true
                docker rm nginx-demo || true
                docker run -d --name nginx-demo -p 8080:80 ${IMAGE_NAME}:latest
                '''
            }
        }

        stage('(Optional) Push to Docker Hub') {
            when {
                expression { return env.DOCKERHUB_USER != '' }
            }
            steps {
                withCredentials([string(credentialsId: 'dockerhub-token', variable: 'DOCKERHUB_PASS')]) {
                    sh '''
                    echo "$DOCKERHUB_PASS" | docker login -u "$DOCKERHUB_USER" --password-stdin
                    docker tag ${IMAGE_NAME}:latest ${DOCKERHUB_USER}/${IMAGE_NAME}:latest
                    docker push ${DOCKERHUB_USER}/${IMAGE_NAME}:latest
                    '''
                }
            }
        }
    }

    post {
        success {
            echo "✅ Deployment successful! Access app at http://<your-server-ip>:8080"
        }
        failure {
            echo "❌ Deployment failed!"
        }
    }
}
