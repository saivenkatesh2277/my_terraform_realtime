region                  = "us-east-1"

vpc_cidr                = "10.0.0.0/16"

public_subnet_cidr_az1  = "10.0.1.0/24"
public_subnet_cidr_az2  = "10.0.2.0/24"

private_subnet_cidr_az1 = "10.0.3.0/24"
private_subnet_cidr_az2 = "10.0.4.0/24"

az1                     = "us-east-1a"
az2                     = "us-east-1b"

instance_type           = "t2.micro"
key_name               = "newkeypairpublic"

desired_capacity        = 2
max_size               = 3
min_size               = 1
