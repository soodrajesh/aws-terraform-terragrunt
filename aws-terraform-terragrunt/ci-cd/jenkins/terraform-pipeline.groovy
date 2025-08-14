pipeline {
    agent any

    parameters {
        choice(name: 'ENV', choices: ['dev', 'prod'], description: 'Select environment to deploy')
    }

    environment {
        AWS_PROFILE = params.ENV == 'dev' ? 'your-dev-profile' : 'your-prod-profile'  # Replace with your AWS profiles
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'git@github.com:your-org/your-repo.git'  # Replace with your repository URL
            }
        }

        stage('Verify AWS Access') {
            steps {
                sh "aws sts get-caller-identity --profile $AWS_PROFILE"
            }
        }

        stage('Terragrunt Init') {
            steps {
                sh "cd envs/${params.ENV} && AWS_PROFILE=$AWS_PROFILE terragrunt init"
            }
        }

        stage('Terragrunt Plan') {
            steps {
                sh "cd envs/${params.ENV} && AWS_PROFILE=$AWS_PROFILE terragrunt plan"
            }
        }

        stage('Terragrunt Apply') {
            steps {
                sh "cd envs/${params.ENV} && AWS_PROFILE=$AWS_PROFILE terragrunt apply -auto-approve"
            }
        }
    }
}
