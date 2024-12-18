provider "aws" {
  region = "ap-southeast-2"
}

resource "aws_instance" "amzn_linux" {
  ami           = "ami-0d6560f3176dc9ec0"
  instance_type = "t2.micro"
  key_name      = "sydney"
  tags = {
    Name = "amz-linux"
  }
}

resource "aws_instance" "ubuntu_linux" {
  ami           = "ami-003f5a76758516d1e"
  instance_type = "t2.micro"
  key_name      = "sydney"
  tags = {
    Name = "ubuntu22"
  }
}


output "amzn_linux_public_ip" {
  value = aws_instance.amzn_linux.public_ip
}

output "ubuntu_linux_public_ip" {
  value = aws_instance.ubuntu_linux.public_ip
}
