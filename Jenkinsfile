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

        stage('Initialize Terraform') {
            steps {
                dir(TERRAFORM_DIR) {
                    // Initialize Terraform
                    sh 'terraform init'
                }
            }
        }

        stage('Check Infrastructure') {
            steps {
                dir(TERRAFORM_DIR) {
                    script {
                        // Check if the infrastructure already exists
                        def infraExists = sh(
                            script: 'terraform show -json | jq ".values.root_module.resources | length > 0"',
                            returnStatus: true
                        ) == 0

                        if (infraExists) {
                            echo "Infrastructure already exists. Moving to the next stage."
                        } else {
                            echo "No existing infrastructure. Proceeding to create it."
                        }
                    }
                }
            }
        }

        stage('Plan Terraform') {
            steps {
                dir(TERRAFORM_DIR) {
                    script {
                        def infraExists = sh(
                            script: 'terraform show -json | jq ".values.root_module.resources | length > 0"',
                            returnStatus: true
                        ) == 0

                        if (!infraExists) {
                            sh 'terraform plan -out=tfplan'
                        } else {
                            echo "Skipping Terraform Plan as infrastructure already exists."
                        }
                    }
                }
            }
        }

        stage('Apply Terraform') {
            steps {
                dir(TERRAFORM_DIR) {
                    script {
                        def infraExists = sh(
                            script: 'terraform show -json | jq ".values.root_module.resources | length > 0"',
                            returnStatus: true
                        ) == 0

                        if (!infraExists) {
                            sh 'terraform apply -input=false tfplan'
                        } else {
                            echo "Skipping Terraform Apply as infrastructure already exists."
                        }
                    }
                }
            }
        }

        stage('Post-Process') {
            steps {
                dir(TERRAFORM_DIR) {
                    echo "Performing post-apply actions."
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
            echo 'Pipeline completed successfully!'
        }
    }
}

