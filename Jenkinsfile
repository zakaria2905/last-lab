pipeline {
    
    agent any 
    

    stages {       // Clone from Git
        stage("Clone App from Git"){
            steps{
               git branch:"master",  url: "https://gitlab.com/mromdhani/pipeline-terraform-ansible.git"
            }          
        }
        
        stage('Terraform Init') {
            steps {
                sh "terraform init "
            }
        }
    
        stage('Terraform Plan') {
            
            
            steps {
               
                    withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', 
                           accessKeyVariable: 'AWS_ACCESS_KEY_ID', 
                           credentialsId: 'my-personal-credential-aws', 
                           secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']]) {
                
                      sh "terraform  plan  -no-color  -out=tfplan"
                    }
                
            }
       }
        stage('Terraform Apply') {
            
            steps {
                    withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', 
                           accessKeyVariable: 'AWS_ACCESS_KEY_ID', 
                           credentialsId: 'my-personal-credential-aws', 
                           secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']]) {
                
                      sh "terraform apply -no-color  -auto-approve  tfplan "
                    }
                
            }
       }
   
   
   
  }
}
