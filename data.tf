data "template_file" "provision_ubuntu" {
  template = "${file("ec2/provision.tpl")}"

  vars {
    volume_size      = "${var.ec2_volume_size}"
    hostname         = "ec2-instance"
    domain           = "local"
    ecs_cluster_name = "${aws_ecs_cluster.main.name}"

    docker_compose     = "${file("ec2/docker-compose.yml")}"
    ecs_config         = "${file("ec2/ecs/ecs.config")}"
    docker_daemon_json = "${file("ec2/docker/daemon.json")}"
  }
}
