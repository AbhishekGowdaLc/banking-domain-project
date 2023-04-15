resource "aws_eip_association" "eip_assoc" {
  instance_id   = aws_instance.deployment-server.id
  allocation_id = "eipalloc-0d2089363c0bfe59b"
}
resource "aws_instance" "deployment-server" {
  ami           = "ami-007855ac798b5175e" 
  instance_type = "t2.medium" 
  key_name = "abhishek"
  vpc_security_group_ids= ["sg-052c64c5480d3301b"]
  connection {
    type     = "ssh"
    user     = "ubuntu"
    private_key = file("./abhishek.pem")
    host     = self.public_ip
  }
  provisioner "remote-exec" {
    inline = [ "echo 'wait to start instance' "]
  }
  tags = {
    Name = "deployment-server"
  }
 provisioner "local-exec" {

        command = " echo ${aws_instance.deployment-server.public_ip} > hostaddress "
 }
 
 provisioner "local-exec" {
 command = "ansible-playbook /var/lib/jenkins/workspace/bankingproject/deployment-server/deploymentServer-playbook.yml"
  } 
}

output "deployment-server_public_ip" {

  value = aws_eip_association.eip_assoc.public_ip
  
}
