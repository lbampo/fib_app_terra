
provider "aws" {
  region = "eu-west-1"
}

# launch first EC2 instance

resource "aws_instance" "app_instance"{
  ami = "${var.app_ami_id}"
  instance_type = "${var.instance_tipe}"
  associate_public_ip_address = true
  subnet_id = "${aws_subnet.Len_Subnet_Pub.id}"
  vpc_security_group_ids = ["${aws_security_group.lba_sg.id}"]
  key_name = "len_terra2"
  user_data = "${data.template_file.app_instance.rendered}"
  tags = {
    Name = "${var.name}"
  }
}


## Public Subnet

resource "aws_subnet" "Len_Subnet_Pub"{
  vpc_id = "vpc-0cf6f02e305e95b7e"

  cidr_block = "10.10.60.4/24"

  tags = {
    Name = "Len-Pub-Subnet"
    Cohort = "Eng-42"
  }
}



## Create Security Group


resource "aws_security_group" "lba_sg" {
  name = "LenLen Destroy SG"
  description = "aws SG from terraform"
  vpc_id = "vpc-0cf6f02e305e95b7e"

  ingress{
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress{
    from_port = 3000
    to_port = 3000
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress{
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["10.10.71.0/24"]
  }


  tags = {
    Name = "LenLen SG"
    Cohort = "Eng42"
  }
}



## Create Route Table

resource "aws_route_table" "public"{
  vpc_id = "${var.vpc_id}"

  route{
    cidr_block = "0.0.0.0/0"
    gateway_id = "${data.aws_internet_gateway.default.id}"
  }

  tags = {
    Name = "${var.name}-public-route"
    Cohort = "Eng-42"
   }
  }

  # Grab a reference to the internet gateway for our vpc

data "aws_internet_gateway" "default"{
    filter{
      name = "attachment.vpc-id"
      values = ["${var.vpc_id}"]
    }
  }




# Route Table Association
resource "aws_route_table_association" "assoc"{
  subnet_id = "${aws_subnet.Len_Subnet_Pub.id}"
  route_table_id = "${aws_route_table.public.id}"

}

# Sending script

data "template_file" "app_instance"{
  template = "${file("./scripts/app/init.sh.tpl")}"
}


resource "aws_key_pair" "deployer2" {
  key_name   = "len_terra2"
  public_key = "${var.len_terra2}"
}
