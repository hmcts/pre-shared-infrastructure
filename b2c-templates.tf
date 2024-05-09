locals {
  b2c_file_paths = fileset(path.module, "b2c/views/**")
  asset_file     = ["png", "svg", "ico", "woff", "woff2"]
  content_file   = ["css", "html", "js"]

  b2c_file_details = {
    for b2c_file_path in local.b2c_file_paths :
    b2c_file_path => {
      name          = basename(b2c_file_path)
      file_name     = b2c_file_path
      relative_path = replace(dirname(b2c_file_path), "b2c/views/", "")
      content_md5   = filemd5("${path.module}/${b2c_file_path}")
      path          = "${path.module}/${b2c_file_path}"

      content = contains(local.content_file, split(".", b2c_file_path)[-1]) ? replace(replace(file("${path.module}/${b2c_file_path}"), "{env}", var.env), "{hostname}", local.hostname) : ""

      content_type = (split(".", b2c_file_path)[1] == "css" ? "text/css" :
        split(".", b2c_file_path)[1] == "js" ? "application/javascript" :
        split(".", b2c_file_path)[1] == "png" ? "image/png" :
        split(".", b2c_file_path)[1] == "svg" ? "image/svg+xml" :
        split(".", b2c_file_path)[1] == "ico" ? "image/x-ico" :
        split(".", b2c_file_path)[1] == "html" ? "text/html" :
        split(".", b2c_file_path)[1] == "woff" ? "font/woff" :
        split(".", b2c_file_path)[1] == "woff2" ? "font/woff2" :
      "application/octet-stream")
    }
  }

  b2c_files          = { for k, v in local.b2c_file_details : k => v }
  b2c_container_name = "${var.product}-b2c-container"

  hostname = var.env == "prod" ? "portal.pre-recorded-evidence.justice.gov.uk" : "pre-portal.${local.env_long_name}.platform.hmcts.net"
  containers = [{
    name        = local.b2c_container_name
    access_type = "container"
  }]
}

output "b2c_files" {
  value = local.b2c_files
}
