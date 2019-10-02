job "mongo" {
  datacenters = ["azure"]
  region      = "${region}"
  type        = "service"
  group "mongo" {
    task "server" {
      driver = "docker"

      config {
        image   = "mongo:3.4.4"
        volumes = ["mongo:/data/db"]
        port_map = {
          mongo = 27017
        }
      }

      resources {
        network {
          mbits = 10
          port "mongo" {}
        }
      }

      service {
        name = "mongodb-azure"
        tags = ["urlprefix-:27017 proto=tcp"]
        port = "mongo"
        check {
          type     = "tcp"
          interval = "10s"
          timeout  = "2s"
        }
      }
    }
  }
}
