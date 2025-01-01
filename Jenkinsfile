pipeline {
    agent any

    environment {
        TERRAFORM_DIR = './Terraform' // Path to your Terraform configuration
    }

    stages {
        stage('Checkout Code') {
            steps {
                // Clone the repository containing the Terraform configuration
                checkout scm
            }
        }

        stage('Setup Environment') {
            steps {
                // Use Jenkins credentials for AWS keys
                withCredentials([
                    string(credentialsId: 'aws-access-key-id', variable: 'AWS_ACCESS_KEY_ID'),
                    string(credentialsId: 'aws-secret-access-key', variable: 'AWS_SECRET_ACCESS_KEY')
                ]) {
                    sh '''
                    export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
                    export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY
                    '''
                }
            }
        }

        stage('Terraform Init') {
            steps {
                dir(TERRAFORM_DIR) {
                    sh 'terraform init'
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                dir(TERRAFORM_DIR) {
                    sh 'terraform plan -out=tfplan'
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                dir(TERRAFORM_DIR) {
                    sh 'terraform apply -input=false tfplan'
                }
            }
        }
    }

    post {
        always {
            cleanWs() // Clean up workspace after the build
        }
        failure {
            echo 'Pipeline failed!'
        }
        success {
            echo 'Infrastructure created successfully!'
        }
    }
}
