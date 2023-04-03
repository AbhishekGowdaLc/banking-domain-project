provider "AWS"{
access_key = "AKIA2F2VO2Y4JRGIRUX4"
secret_key = "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"
region = "us-east-1"
}

resource aws_instance "test-server"{
ami = "ami-007855ac798b5175e"
instance_type = "t2.micro"
}
