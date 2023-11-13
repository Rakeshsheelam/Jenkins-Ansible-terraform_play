pipeline {
    agent any

    environment {
        AWS_REGION = 'us-east-1'
        AMAZON_KEY_PAIR = 'linux'
        UBUNTU_KEY_PAIR = 'ubuntu-key'
    }

    stages {
        

        stage('Checkout') {
            steps {
                checkout([$class: 'GitSCM', branches: [[name: '*/main']], doGenerateSubmoduleConfigurations: false, extensions: [], submoduleCfg: [], userRemoteConfigs: [[credentialsId: '', url: 'https://github.com/Hussain147/tf-ansible-task.git/']]]) 
            }
        }
        
        stage('Check Instances') {
            steps {
                script {
                    // Use AWS CLI to check if instances exist
                    def instanceCount = sh(script: "aws ec2 describe-instances --query 'Reservations[*].Instances[*].InstanceId' --output text | wc -w", returnStatus: true).trim()

                    if (instanceCount.toInteger() > 0) {
                        echo "Instances already exist. Skipping creation."
                        currentBuild.result = 'SUCCESS'
                        return
                    }
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                script {
                    sh 'terraform init'
                    sh 'terraform apply -auto-approve'
                }
            }
        }

        stage('Generate Ansible Inventory') {
            steps {
                script {
                    sh 'chmod +x generate_inventory.sh'
                    sh './generate_inventory.sh > inventory.ini'
                }
            }
        }

        stage('Ansible Deployment') {
            steps {
                script {
                    ansiblePlaybook(
                        playbook: 'amazon-playbook.yml',
                        inventory: 'inventory.ini',
                        extras: "-e 'ansible_ssh_user=ec2-user -e ansible_ssh_private_key_file=~/.ssh/${AMAZON_KEY_PAIR}.pem'"
                    )

                    ansiblePlaybook(
                        playbook: 'ubuntu-playbook.yml',
                        inventory: 'inventory.ini',
                        extras: "-e 'ansible_ssh_user=ubuntu -e ansible_ssh_private_key_file=~/.ssh/${UBUNTU_KEY_PAIR}.pem'"
                    )
                }
            }
        }
    }
}
