pipeline {
    agent any

    environment {
        IMAGE_NAME = "nginx-demo"
        DOCKERHUB_USER = "sashikumar24"
    }

    stages {
        stage('Checkout') {
            steps {
                echo "Pulling source code from GitHub..."
                git branch: 'main', url: 'https://github.com/yourusername/nginx-demo.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                echo "Building Docker image..."
                sh "docker build -t ${IMAGE_NAME}:latest ."
            }
        }

        stage('Run Container Locally') {
            steps {
                echo "Running container on port 8080..."
                sh '''
                docker stop nginx-demo || true
                docker rm nginx-demo || true
                docker run -d --name nginx-demo -p 8080:80 nginx-demo:latest
                '''
            }
        }

        stage('Push to DockerHub') {
            steps {
                echo "Pushing image to DockerHub..."
                withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
                    sh '''
                    echo "$PASSWORD" | docker login -u "$USERNAME" --password-stdin
                    docker tag nginx-demo:latest ${USERNAME}/nginx-demo:latest
                    docker push ${USERNAME}/nginx-demo:latest
                    docker logout
                    '''
                }
            }
        }
    }

    post {
        success {
            echo "✅ Deployment successful! Access at http://<your-server-ip>:8080"
        }
        failure {
            echo "❌ Deployment failed!"
        }
    }
}

