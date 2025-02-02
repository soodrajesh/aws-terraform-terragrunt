pipeline {
    agent any

    parameters {
        choice(name: 'ENV', choices: ['dev', 'prod'], description: 'Select environment to deploy')
    }

    environment {
        AWS_PROFILE = params.ENV == 'dev' ? 'account1-admin' : 'account2-admin'
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'git@bitbucket.org:your-repo.git'
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
