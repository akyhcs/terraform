terraform {
  backend "local" {
     path = "/var/tmp/terraform-local-backend/terraform.tfstate"
    # this file need to be created prior
    # sudo chmod -R 777 /var/tmp/terraform-local-backend/
  }
}


provider "aws" {
   region = "us-east-1"
   version = ">=3.7,<=3.11"
}


resource "aws_instance" "frontend" {
  ami           = "ami-0739f8cdb239fe9ae"
#  ami           = "ami-0ebc8f6f580a04647"
  instance_type = "t2.micro"
  depends_on    = [aws_instance.backend]

 # lifecycle {
  #   create_before_destroy = true
  #}


}

resource "aws_instance" "backend" {
  ami           = "ami-0739f8cdb239fe9ae"
  instance_type = "t2.micro"
  count         = 2

  lifecycle {
    prevent_destroy = false
  }
}

output "backend_public_ips" {
  value = aws_instance.backend.*.public_ip
}
output "backend_public_dns" {
  value = aws_instance.backend.*.public_dns
}


output "frontend_public_ips" {
  value = aws_instance.frontend.*.public_ip
}



output "backend_ips" {
  value = "${list(aws_instance.backend.*.public_ip, aws_instance.backend.*.private_ip)}"
}

