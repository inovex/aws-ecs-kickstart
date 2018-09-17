resource "aws_lb" "lb" {
  name                       = "${var.naming}-loadbalancer"
  security_groups            = ["${aws_security_group.sg-loadbalancer.id}"]
  subnets                    = ["${aws_subnet.subnet-a.id}", "${aws_subnet.subnet-b.id}"]
  enable_deletion_protection = false
}

resource "aws_lb_listener" "lb-http" {
  load_balancer_arn = "${aws_lb.lb.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.example-service.arn}"
  }
}

resource "aws_lb_target_group" "example-service" {
  name                 = "${var.naming}-example-service"
  port                 = 80
  protocol             = "HTTP"
  vpc_id               = "${aws_vpc.vpc.id}"
  deregistration_delay = 30

  health_check {
    path                = "/"
    matcher             = "200"
    interval            = 10
    healthy_threshold   = 3
    unhealthy_threshold = 3
    timeout             = 2
  }
}

resource "aws_lb_listener_rule" "example-service" {
  listener_arn = "${aws_lb_listener.lb-http.arn}"
  priority     = 101

  action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.example-service.arn}"
  }

  condition {
    field  = "host-header"
    values = ["example-service.local"]
  }
}
