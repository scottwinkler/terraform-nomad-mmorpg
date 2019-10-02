job "fabio" {
  datacenters = ["azure"]
  region = "${region}"
  type = "system"
  group "fabio" {
    task "fabio" {
      driver = "docker"
      config {
        image = "fabiolb/fabio"
        network_mode = "host"
        volumes = ["/etc/fabio/fabio.properties:/etc/fabio/fabio.properties"]
      }

      resources {
        cpu    = 200
        memory = 128
        network {
          mbits = 20
          port "db" {
            static = 27017
          }
          port "ui" {
            static = 9998
          }
        }
      }
    }
  }
}