variable "private_key_path" {
  type        = string
  description = "Chemin vers la clé privée SSH utilisée pour se connecter à l'instance"
  default     = "" //TODO change this to your own
}
variable "key_name" {
  type        = string
  description = "Nom de la clé SSH"
  default    = "" //TODO change this to your own
}

variable "access_key" {
  type        = string
  description = "Clé d'accès AWS"
  default     = "" //TODO change this to your own
}
variable "secret_key"   {
  type        = string
  description = "Clé secrète AWS"
  default    = "" //TODO change this to your own
}


provider "aws" {
  region = "eu-west-3"
  access_key = var.access_key
  secret_key = var.secret_key
}

resource "aws_instance" "ma_ubuntu_vm" {
  ami           = "ami-00ac45f3035ff009e"
  instance_type = "t2.micro"
  key_name      = var.key_name
  vpc_security_group_ids = [ aws_security_group.ma_ubuntu_vm_sg.id ]
  tags = {
    Name = "TerraformUbuntuVM"
  }
}

resource "aws_security_group" "ma_ubuntu_vm_sg" {
  name        = "ma_ubuntu_vm_sg"
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
    host        = aws_instance.ma_ubuntu_vm.public_ip
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
  depends_on = [aws_instance.ma_ubuntu_vm]
}

output "site_result_URL" {
  value = "${aws_instance.ma_ubuntu_vm.public_ip}:${5001}"
}
output "site_vote_URL" {
  value = "${aws_instance.ma_ubuntu_vm.public_ip}:${5000}"
}