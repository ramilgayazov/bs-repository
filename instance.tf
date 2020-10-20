#----------Instance---------
resource "aws_instance" "bsins" {
  ami                    = var.ami
  subnet_id              = var.private_subnet
  instance_type          = var.instance_type
  iam_instance_profile   = aws_iam_instance_profile.ec2_profile.name
  key_name               = var.key_name
  user_data = file("user_data_bs.sh")
  vpc_security_group_ids = var.ec2_sg_group

  tags = {
    Name = "BESTSELLER"
  }

  root_block_device {
    volume_type = var.root_volume_type
    volume_size = var.root_volume_size
  }
}

