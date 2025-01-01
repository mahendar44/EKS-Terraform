pipeline {
    agent any
    environment {
        AWS_ACCESS_KEY_ID     = 'aws-access-key-id'
        AWS_SECRET_ACCESS_KEY = 'aws-secret-access-key'
        AWS_DEFAULT_REGION    = 'us-east-1'  // Set your AWS region
    }


    
    stages {
        stage('Terraform Init') {
            steps {
                script {
                    echo 'Running terraform init...'
                    sh 'terraform init'  // Initializes Terraform working directory
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                script {
                    echo 'Running terraform plan...'
                    // Run terraform plan and capture the result
                    def planResult = sh(script: 'terraform plan -detailed-exitcode', returnStatus: true)
                    if (planResult == 0) {
                        echo 'No changes required. Skipping apply.'
                    } else if (planResult == 2) {
                        echo 'Changes detected, proceeding to apply.'
                    } else {
                        error 'Error in terraform plan.'
                    }
                }
            }
        }

        stage('Terraform Apply') {
            when {
                expression {
                    // Only apply if terraform plan showed changes (exit code 2)
                    return currentBuild.result == null || currentBuild.result == 'SUCCESS'
                }
            }
            steps {
                script {
                    echo 'Running terraform apply...'
                    // Applying the changes to create the infrastructure
                    sh 'terraform apply -auto-approve'
                }
            }
        }

        stage('Terraform Destroy') {
            steps {
                script {
                    echo 'Running terraform destroy...'
                    // Destroys the infrastructure without confirmation
                    sh 'terraform destroy -auto-approve'
                }
            }
        }
    }

    post {
        always {
            echo 'Cleaning up...'
            // Optionally, you can add steps here for things like Terraform state cleanup
        }
        success {
            echo 'Pipeline ran successfully!'
        }
        failure {
            echo 'Pipeline failed. Please check the logs.'
        }
    }
}
