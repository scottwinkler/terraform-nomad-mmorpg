provider "nomad" {
  alias = "aws"
}

provider "nomad" {
  alias = "azure"
}

data "nomad_regions" "current" {
  provider = nomad.aws
}

locals {
  aws_region = sort(data.nomad_regions.current.regions)[1]
  azure_region = sort(data.nomad_regions.current.regions)[0]
}

resource "nomad_job" "aws_fabio" {
  jobspec = templatefile("${path.module}/jobs/aws_fabio.hcl",{region = local.aws_region})
  provider = nomad.aws
}

resource "nomad_job" "azure_fabio" {
  jobspec = templatefile("${path.module}/jobs/azure_fabio.hcl",{region = local.azure_region})
  provider = nomad.azure
}

resource "nomad_job" "azure_mongo" {
  jobspec = templatefile("${path.module}/jobs/mongo.hcl",{region = local.azure_region})
  provider = nomad.azure
}

resource "nomad_job" "aws_browserquest" {
  jobspec = templatefile("${path.module}/jobs/browserquest.hcl",{region=local.aws_region,address=replace(var.fabio_db,"tcp://","")})
  provider = nomad.aws
}
