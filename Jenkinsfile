pipeline {
    agent any

    environment {
        AWS_REGION = 'ap-southeast-2'
        AMAZON_KEY_PAIR = 'sydney'
        UBUNTU_KEY_PAIR = 'sydney'
    }

    stages {
        

        stage('Checkout') {
            steps {
                checkout([$class: 'GitSCM', branches: [[name: '*/main']], doGenerateSubmoduleConfigurations: false, extensions: [], submoduleCfg: [], userRemoteConfigs: [[credentialsId: '', url: 'https://github.com/Rakeshsheelam/Jenkins-Ansible-terraform_play.git/']]]) 
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
