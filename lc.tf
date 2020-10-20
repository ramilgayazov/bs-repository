#--------Launch configuration--------

resource "aws_launch_configuration" "bslc" {
  name_prefix = "bslc"
  image_id = var.ami
  instance_type = var.instance_type
  key_name = "bs-key"
  user_data = file("user_data_bs.sh")
  security_groups = var.ec2_sg_group
  associate_public_ip_address = true
  lifecycle {
    create_before_destroy = true
  }
  root_block_device {
          volume_type = var.root_volume_type
          volume_size = var.root_volume_size
  }
}

