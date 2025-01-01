pipeline {
    agent any

    environment {
        // Specify the directory where Terraform will run
        TERRAFORM_DIR = './terraform'
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
                    // Export AWS credentials as environment variables
                    sh '''
                    export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
                    export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY
                    '''
                }
            }
        }

        stage('Initialize Terraform') {
            steps {
                dir(TERRAFORM_DIR) {
                    // Initialize Terraform
                    sh 'terraform init'
                }
            }
        }

        stage('Plan Terraform') {
            steps {
                dir(TERRAFORM_DIR) {
                    // Plan Terraform changes
                    sh 'terraform plan -out=tfplan'
                }
            }
        }

        stage('Apply Terraform') {
            steps {
                dir(TERRAFORM_DIR) {
                    // Apply Terraform changes
                    sh 'terraform apply -input=false tfplan'
                }
            }
        }

        stage('Post-Apply') {
            steps {
                dir(TERRAFORM_DIR) {
                    // Optionally output the Terraform state or resources
                    sh 'terraform output'
                }
            }
        }
    }

    post {
        always {
            // Clean up sensitive information
            cleanWs()
        }
        failure {
            echo 'Pipeline failed!'
        }
        success {
            echo 'Infrastructure created successfully!'
        }
    }
}
