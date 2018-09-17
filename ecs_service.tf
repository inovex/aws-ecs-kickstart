resource "aws_ecs_service" "example-service" {
  count           = "1"
  name            = "example-service"
  cluster         = "${aws_ecs_cluster.main.id}"
  task_definition = "${aws_ecs_task_definition.example-service.arn}"
  desired_count   = 1
  iam_role        = "${aws_iam_role.role-ecs-service.name}"

  ordered_placement_strategy {
    type  = "spread"
    field = "instanceId"
  }

  load_balancer {
    target_group_arn = "${aws_lb_target_group.example-service.arn}"
    container_name   = "web"
    container_port   = 80
  }
}

data "template_file" "task" {
  template = "${file("ecs-task.json")}"

  vars {
    image_version = "latest"
  }
}

resource "aws_ecs_task_definition" "example-service" {
  family                = "example-service"
  container_definitions = "${data.template_file.task.rendered}"
}
