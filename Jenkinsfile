pipeline {
    agent any

    environment {
        TERRAFORM_DIR = './Terraform' // Path to your Terraform files
    }

    stages {
        stage('Checkout Code') {
            steps {
                // Pull the repository containing the Terraform files
                checkout scm
            }
        }

        stage('Setup Environment') {
            steps {
                // Export AWS credentials and default region from Jenkins secrets
                withCredentials([
                    string(credentialsId: 'aws-access-key-id', variable: 'AWS_ACCESS_KEY_ID'),
                    string(credentialsId: 'aws-secret-access-key', variable: 'AWS_SECRET_ACCESS_KEY')
                ]) {
                    sh '''
                    export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
                    export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY
                    echo "AWS environment variables exported."
                    '''
                }
            }
        }

        stage('Terraform Init') {
            steps {
                dir(TERRAFORM_DIR) {
                    // Initialize Terraform
                    sh 'terraform init'
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                dir(TERRAFORM_DIR) {
                    // Run Terraform plan and save the output to a file
                    sh 'terraform plan -var-file=terraform.tfvars -out=tfplan'
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                dir(TERRAFORM_DIR) {
                    // Apply the Terraform plan with auto-approve
                    sh 'terraform destroy -input=false --auto-approve'
                }
            }
        }
    }

    post {
        always {
            cleanWs() // Clean workspace after pipeline completion
        }
        success {
            echo 'Terraform infrastructure created successfully.'
        }
        failure {
            echo 'Pipeline failed.'
        }
    }
}
