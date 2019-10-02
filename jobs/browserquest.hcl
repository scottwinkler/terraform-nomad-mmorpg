job "browserquest" {
  datacenters = ["aws"]
  region      = "${region}"

  group "browserquest" {
    task "server" {
      driver = "docker"

      config {
        image   = "swinkler/browserquest"
        command = "/bin/bash"
        args = [
          "-c",
          "node server.js --mongoServer ${address}"
        ]

        port_map {
          http = "8080"
        }

      }

      resources {
        network {
          mbits = 10
          port "http" {}
        }
      }

      service {
        name = "browserquest-aws"
        tags = ["urlprefix-/"]
        port = "http"
        check {
          name     = "alive"
          type     = "http"
          path     = "/"
          interval = "10s"
          timeout  = "2s"
        }
      }

    }
  }
}
