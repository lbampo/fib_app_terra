# Bastion EC2 instance

resource "aws_instance" "bastion_instance"{
  ami = "${var.app_ami_id}"
  instance_type = "${var.instance_tipe}"
  associate_public_ip_address = true
  subnet_id = "${aws_subnet.Len_Bas_Subnet.id}"
  vpc_security_group_ids = ["${aws_security_group.bastion_sg.id}"]
  key_name = "len_terra"
  ##user_data = "${data.template_file.app_instance.rendered}"
  tags = {
    Name = "${var.name_bas}"
  }
}

## Bastion Subnet

resource "aws_subnet" "Len_Bas_Subnet"{
  vpc_id = "vpc-07e47e9d90d2076da"

  cidr_block = "172.31.78.0/24"

  tags = {
    Name = "Len-Bas-Subnet"
    Cohort = "Eng-42"
  }
}

## Bastion Security Group

resource "aws_security_group" "bastion_sg" {
  name = "BasBas Destroy SG"
  description = "bastion SG from terraform"
  vpc_id = "vpc-07e47e9d90d2076da"

  ingress{
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["212.161.55.68/32"]
  }

  egress{
  from_port = 22
  to_port = 22
  protocol = "tcp"
  cidr_blocks = ["172.31.8.0/24"]
  }

  tags = {
    Name = "BasBas SG!"
    Cohort = "Eng42"
  }
}

# Bastion Route Table Association
resource "aws_route_table_association" "bas_assoc"{
  subnet_id = "${aws_subnet.Len_Bas_Subnet.id}"
  route_table_id = "${aws_route_table.public.id}"

}

resource "aws_key_pair" "deployer" {
  key_name   = "len_terra"
  public_key = "${var.ssh_terra}"
}
