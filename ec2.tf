resource "aws_instance" "ec2" {
  ami               = "ami-09b429d0b1d601b97"
  instance_type     = "t2.micro"
  availability_zone = "ap-south-1a"
  key_name          = "terraform-ansible-ec2"
  tags = {
    Name = "Terraform-ansible-ec2"
  }

  provisioner "remote-exec" {
    inline = [ 
      "sudo hostnamectl set-hostname myec2.cloudbook.com"
      
    ]
    connection {
      host        = aws_instance.ec2.public_dns
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("/var/lib/jenkins/workspace/Demo-AWS-EC2-Infrastructure-Pipeline/terraform-ansible-ec2.pem")
    }
  }

  provisioner "local-exec" {
    command = "echo ${aws_instance.ec2.public_dns} > inventory"
  }

}

output "ip" {
  value = aws_instance.ec2.public_ip
}

output "publicName" {
  value = aws_instance.ec2.public_dns
}
