pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                // Checkout the source code from SCM (e.g., Git)
                checkout scm
            }
        }

        stage('Initialize Terraform') {
            steps {
                script {
                    // Initialize Terraform (downloads necessary providers and modules)
                    sh 'terraform init'
                }
            }
        }

        stage('Plan Infrastructure') {
            steps {
                script {
                    // Run terraform plan to preview the changes before applying them
                    sh 'terraform plan -out=tfplan'
                }
            }
        }

        stage('Apply Infrastructure') {
            steps {
                script {
                    // Apply the Terraform plan to create the infrastructure
                    sh 'terraform apply -auto-approve tfplan'
                }
            }
        }

        stage('Verify Infrastructure') {
            steps {
                script {
                    // Optional: Run any verification commands, like Terraform output or API checks
                    sh 'terraform output'
                }
            }
        }

        stage('Cleanup') {
            steps {
                script {
                    // Optional: Clean up any temporary files or directories
                    sh 'rm -rf .terraform tfplan'
                }
            }
        }
    }

    post {
        always {
            // Always clean up resources or handle any post-build actions
            echo 'Cleaning up...'
            // Add any cleanup logic here if necessary
        }
        
        success {
            // Handle success (e.g., notify a user or send an email)
            echo 'Infrastructure has been successfully created.'
        }

        failure {
            // Handle failure (e.g., notify a user or send an email)
            echo 'There was an error creating the infrastructure.'
        }
    }
}

