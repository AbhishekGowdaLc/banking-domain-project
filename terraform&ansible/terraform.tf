provider "aws"{
access_key = "AKIA2F2VO2Y4JRGIRUX4"
secret_key = "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"
region = "us-east-1"
}

resource "aws_instance" "my_instance"{
 ami = "ami-007855ac798b5175e"
 instance_type = "t2.micro"
 availability_zone = "us-east-1a"
   tags = {
     Name = "test-server"
}



 provisioner "remote-exec"{
  inline = [echo 'started remote exec']
   connection {
    host = aws_instance.my_instance.public_dns
    type = "ssh"
    user = "ec2-user"
    private_key = file("./abhishek.pem")
   }
}

 provisioner "local-exec"{
  command = "echo ${aws_instance.my_instance.public_dns} > inventory"
}

 provisioner "local-exec"{
   command = "ansible all -m shell -a 'sudo apt-get install -y docker.io; sudo systemctl start docker'"
}
}


output "ip" {
  value = aws_instance.my_instance.public_ip
}

output "publicName" {
  value = aws_instance.my_instance.public_dns
}
