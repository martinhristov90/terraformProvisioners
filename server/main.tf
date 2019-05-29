variable "ami" {}
variable "instance_type" {}
variable subnet_id {}
variable vpc_security_group_ids {}

resource "aws_instance" "web" {

    ami           = "${var.ami}"
    instance_type = "${var.instance_type}"
    subnet_id     = "${var.subnet_id}"
    key_name      = "${aws_key_pair.training.id}"

    vpc_security_group_ids = [
       "${var.vpc_security_group_ids}"
    ]


    connection {
        user = "ubuntu"
        private_key = "${file("~/.ssh/id_rsa")}"
    }

    provisioner "file" {
        source = "./test.sh"
        destination = "/tmp/"
    }
    
    provisioner "remote-exec" {
        inline = [ 
            "bash /tmp/test.sh"
        ]
    }
    
    tags {
        "name" = "MYMACHINE"
    }
}

resource "aws_key_pair" "training" {
    key_name = "MYMACHINE-key"
    public_key = "${file("~/.ssh/id_rsa.pub")}"
}


output "public_ip" {
    value = "${aws_instance.web.public_ip}"
}
output "public_dns" {
    value = "${aws_instance.web.public_dns}"
}      
