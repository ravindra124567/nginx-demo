pipeline {
    agent any

    environment {
        IMAGE_NAME = "nginx-demo"
    }

    parameters {
        string(name: 'NGINX_PORT', defaultValue: '8081', description: 'Port to run Nginx container (not 8080)')
        string(name: 'DOCKERHUB_USER', defaultValue: 'sashikumar24', description: 'DockerHub username')
    }

    stages {
        stage('Checkout') {
            steps {
                echo "Pulling source code from GitHub..."
                git branch: 'main',
                    url: 'https://github.com/ravindra124567/nginx-demo.git',
                    credentialsId: 'GITS_CREDENTIAL'
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
                echo "Running container on port ${params.NGINX_PORT}..."
                sh '''
                docker stop nginx-demo || true
                docker rm nginx-demo || true
                docker run -d --name nginx-demo -p ${NGINX_PORT}:80 nginx-demo:latest
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
            echo "✅ Deployment successful! Access at http://<your-server-ip>:${params.NGINX_PORT}"
        }
        failure {
            echo "❌ Deployment failed!"
        }
    }
}
