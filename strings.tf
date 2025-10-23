
resource "random_string" "random_postfix" {
  length  = 8
  lower   = true
  upper   = false
  special = false
}

resource "random_string" "jwt_secret" {
  length  = 64
  lower   = true
  upper   = false
  special = false
}

resource "random_string" "jwt_refresh_secret" {
  length  = 64
  lower   = true
  upper   = false
  special = false
}

resource "random_id" "creds_key" {
  byte_length = 32
}

resource "random_id" "creds_iv" {
  byte_length = 16
}

resource "random_string" "meilisearch_master_key" {
  length  = 20
  special = false
}

resource "random_string" "mongo_root_password" {
  length  = 32
  lower   = true
  upper   = false
  special = false
}
