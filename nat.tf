resource "aws_nat_gateway" "gw" {
  allocation_id = var.eip
  subnet_id     = var.public_subnet
}
