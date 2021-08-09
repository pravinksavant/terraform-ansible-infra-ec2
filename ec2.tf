resource "aws_instance" "ec2" {
  ami               = "ami-04db49c0fb2215364"
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
  
  provisioner "local-exec" {
    command = "cp /var/lib/jenkins/workspace/Demo-AWS-EC2-Infrastructure-Pipeline/terraform-ansible-ec2.pem /tmp/"
	  
  }
  provisioner "local-exec" {
    command = "chmod 600 /tmp/terraform-ansible-ec2.pem"
	  
  }

  provisioner "local-exec" {
    command = "ansible all -m shell -a 'yum -y install httpd; systemctl restart httpd'"
  }
}

output "ip" {
  value = aws_instance.ec2.public_ip
}

output "publicName" {
  value = aws_instance.ec2.public_dns
}
