resource "aws_ecs_cluster" "main" {
  name = "${var.naming}-ecs-cluster"
}

resource "aws_ecr_repository" "main" {
  name = "${var.naming}-ecr"
}
