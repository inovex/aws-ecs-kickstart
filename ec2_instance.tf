resource "aws_autoscaling_group" "ec2_instances" {
  name                 = "${var.naming}-ec2-"
  availability_zones   = ["eu-central-1a"]
  min_size             = "1"
  max_size             = "3"
  desired_capacity     = "1"
  health_check_type    = "EC2"
  launch_configuration = "${aws_launch_configuration.ec2_instance.name}"
  vpc_zone_identifier  = ["${aws_subnet.subnet-a.id}", "${aws_subnet.subnet-b.id}"]
  termination_policies = ["OldestLaunchConfiguration", "OldestInstance"]

  tags = [
    {
      key                 = "group"
      value               = "${var.naming}-ags-ec2-instances"
      propagate_at_launch = true
    },
    {
      key                 = "Name"
      value               = "${var.naming}-ec2-instances"
      propagate_at_launch = true
    },
  ]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_launch_configuration" "ec2_instance" {
  name_prefix                 = "${var.naming}-ec2-"
  image_id                    = "${var.ec2_ami}"
  instance_type               = "${var.ec2_node_type}"
  security_groups             = ["${aws_security_group.ingress-ec2-instance.id}", "${aws_security_group.egress-ec2-instance.id}"]
  associate_public_ip_address = true
  enable_monitoring           = false
  iam_instance_profile        = "${var.naming}-instance-profile-ecs-clusternode"
  key_name                    = "${aws_key_pair.ec2-key.key_name}"
  user_data                   = "${data.template_file.provision_ubuntu.rendered}"

  root_block_device {
    volume_size = "${var.ec2_volume_size}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_key_pair" "ec2-key" {
  key_name   = "${var.naming}-key-ec2-instance"
  public_key = "${file("~/.ssh/id_rsa.pub")}"
}
