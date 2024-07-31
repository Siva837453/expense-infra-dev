resource "aws_key_pair" "vpn" {
  key_name = "openvpn"
  #you can paste the public key like this or you can refer the public key from file
  //public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEq5RYt/kgifzG1WlS+GWUI6tt3Q6qwNxCEYKkCcKpDz sivaa@Sivakumar"
  public_key = file("~/.ssh/openvpn.pub")
  # ~ this means Windows home directory

}


module "vpn" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  key_name = aws_key_pair.vpn.key_name

  name = "${var.Project_name}-${var.environment}-vpn"

  instance_type          = "t3.micro"
  
  vpc_security_group_ids = [data.aws_ssm_parameter.vpn_sg_id.value]
  #converting StringList to list
  subnet_id              = local.public_subnet_id
  ami = data.aws_ami.ami_info.id
 
  tags = merge(
    var.common_tags,
    {
        Name= "${var.Project_name}-${var.environment}-vpn"
    }

  )
}



# vpn admin acess:  ssh -i ~/.ssh/openvpn openvpnas@<IP.ADDRESS>
