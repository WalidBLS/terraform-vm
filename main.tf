variable "private_key_path" {
  type        = string
  description = "Chemin vers la clé privée SSH utilisée pour se connecter à l'instance"
  default     = "" //TODO change this to your own
}

provider "aws" {
  region = "eu-west-3"
  access_key = "" //TODO change this to your own
  secret_key = "" //TODO change this to your own
}

resource "aws_instance" "ma_vm" {
  ami           = "ami-00ac45f3035ff009e"
  instance_type = "t2.micro"
  key_name      = "" //TODO change this to your own
  vpc_security_group_ids = [ aws_security_group.ma_vm_sg.id ]
  tags = {
    Name = "TerraformUbuntuVM"
  }
}

resource "aws_security_group" "ma_vm_sg" {
  name        = "ma_vm_sg"
  description = "Security group for my VM"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 5000
    to_port     = 5001
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

resource "null_resource" "example" {

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file(var.private_key_path)
    host        = aws_instance.ma_vm.public_ip
    timeout     = "2m"
  }

  provisioner "file" {
    source = "./script.sh"
    destination = "/tmp/script.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo mv /tmp/script.sh ./",
      "sudo chmod 777 ./script.sh",
      "./script.sh",
    ]
  }
  depends_on = [aws_instance.ma_vm]
}

output "public_ip" {
  value = aws_instance.ma_vm.public_ip
}