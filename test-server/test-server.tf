provider "aws"{
access_key = "AKIA2F2VO2Y4JRGIRUX4"
secret_key = "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"
region = "us-east-1"
}

resource "aws_eip_association" "eip_assoc"{
  instance_id = aws_instance.test-server.id
  allocatio_id = "eipalloc-0d2089363c0bfe59b"
}	
	

resource "aws_instance" "test-server"{
 ami = "ami-007855ac798b5175e"
 instance_type = "t2.micro"
 key_name = "abhishek"
 vpc_security_grp_ids = ["sg-0d42aaa78deb47d92"]
 availability_zone = "us-east-1a"
   connections {
    type = "ssh"
	user = "ec2-user" 
	key = file("./abhishek.pem")
	host = self.public_ip
	}
provisioner "remote-exec"{
   inline = ["echo 'started remote exec'"]
}

tags = {
  Name = "test-server"
}

provisioner "local-exec"{
 command = "echo $(aws_instance.test-server.public_ip) > inventory"
}


provisioner "local-exec"{
  command = "ansible-playbook /var/lib/jenkins/workspace/banking-project/test-server/test-server-playbook.yml"
}

output "ip" {
  value = aws_instance.test-server.public_ip
}
}
