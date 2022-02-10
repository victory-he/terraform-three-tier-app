resource "aws_launch_template" "web" {
  ebs_optimized           = "false"
  image_id                = "ami-0a8b4cd432b1c3063"
  instance_type           = "t3a.medium"
  key_name                = "sigr"
  name                    = "valheim-al2-launch"
  tags                    = {}
  user_data               = file("install_valheim.sh")
  vpc_security_group_ids  = [
      "sg-09b90290ef1e48bd4",
  ]

  block_device_mappings {
    device_name = "/dev/xvda"

      ebs {
          delete_on_termination = "true"
          encrypted             = "false"
          volume_size           = 8
          volume_type           = "gp3"
      }
  }
  block_device_mappings {
      device_name = "/dev/sda1"
      no_device   = "true"
  }

  iam_instance_profile {
      arn = "arn:aws:iam::324491862083:instance-profile/valheim-server-2022"
  }

  instance_market_options {
      market_type = "spot"

      spot_options {
        - block_duration_minutes = 0
        - spot_instance_type     = "one-time"
      }
  }


}
