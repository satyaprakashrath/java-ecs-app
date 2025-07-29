resource "aws_security_group" "bastion_sg" {
  name        = "bastion-sg"
  description = "Allow SSH"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["122.171.22.212/32"]  # tighten this, don't use 0.0.0.0/0
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "bastion" {
  ami                    = "ami-0be5f59fbc80d980c"  # Amazon Linux 2 (check latest for us-west-2)
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public[0].id
  key_name               = "US-west2-KP"
  associate_public_ip_address = true
  vpc_security_group_ids = [aws_security_group.bastion_sg.id]

  tags = {
    Name = "bastion-host"
  }
}
