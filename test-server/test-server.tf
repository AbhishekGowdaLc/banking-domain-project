resource "aws_eip_association" "eip_assoc" {
  instance_id   = aws_instance.test-server.id
  allocation_id = "eipalloc-0d2089363c0bfe59b"
}
resource "aws_instance" "test-server" {
  ami           = "ami-00c39f71452c08778" 
  instance_type = "t2.micro" 
  key_name = "abhishek"
  vpc_security_group_ids= ["sg-0d42aaa78deb47d92"]
  connection {
    type     = "ssh"
    user     = "ec2-user"
    private_key = file("./abhishek.pem")
    host     = self.public_ip
  }
  provisioner "remote-exec" {
    inline = [ "echo 'wait to start instance' "]
  }
  tags = {
    Name = "test-server"
  }
 provisioner "local-exec" {

        command = " echo ${aws_instance.test-server.public_ip} > inventory "
 }
 
 provisioner "local-exec" {
 command = "ansible-playbook /var/lib/jenkins/workspace/project-02-banking/test-server/test-server-playbook.yml "
  } 
}

output "test-server_public_ip" {

  value = aws_eip_association.eip_assoc.public_ip
  
}
