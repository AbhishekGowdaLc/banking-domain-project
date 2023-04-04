resource "aws_eip_association" "eip_assoc"{
  instance_id = aws_instance.test-server.id
  allocation_id = "eipalloc-0d2089363c0bfe59b"
}	
	

resource "aws_instance" "prod-server"{
 ami = "ami-007855ac798b5175e"
 instance_type = "t2.micro"
 key_name = "abhishek"
 vpc_security_group_ids = ["sg-0d42aaa78deb47d92"]
 availability_zone = "us-east-1a"
   connection {
        type = "ssh"
	user = "ubuntu" 
	private_key = file("./abhishek.pem")
	host = self.public_ip
	}
provisioner "remote-exec"{
   inline = ["echo 'started remote exec'"]
}

tags = {
  Name = "prod-server"
}

provisioner "local-exec"{
 command = "echo $(aws_instance.prod-server.public_ip) > inventory"
}


provisioner "local-exec"{
  command = "ansible-playbook /var/lib/jenkins/workspace/banking-project/test-server/prod-server-playbook.yml"
}
}
output "ip" {
  value = aws_instance.prod-server.public_ip
}
