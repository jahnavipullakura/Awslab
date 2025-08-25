resource "aws_instance" "jenkins_server" {
  ami           = "ami-02d7ced41dff52ebc" 
  instance_type = "t2.medium"
  subnet_id     = aws_subnet.dragons_subnet.id
  security_groups = [aws_security_group.dragons_sg.id]
  key_name      = "deploydragons"  # replace with your AWS key pair

  tags = { Name = "Deploydragons-jenkins-server" }
}

output "jenkins_public_ip" {
  value = aws_instance.jenkins_server.public_ip
}