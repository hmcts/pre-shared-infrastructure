locals {
  b2c_file_paths = fileset(path.module, "b2c/views/**")
  asset_file     = ["png", "svg", "ico", "woff", "woff2"]
  content_file   = ["css", "html"]

  b2c_file_details = {
    for b2c_file_path in local.b2c_file_paths :
    b2c_file_path => {
      name          = basename(b2c_file_path)
      file_name     = b2c_file_path
      relative_path = replace(dirname(b2c_file_path), "b2c/views/", "")
      content_md5   = filemd5("${path.module}/${b2c_file_path}")
      path          = "${path.module}/${b2c_file_path}"

      content = contains(local.asset_file, split(".", b2c_file_path)[1]) ? "" : replace(replace(file("${path.module}/${b2c_file_path}"), "{env}", var.env), "{env_long_name}", local.env_long_name)

      content_type = {
        "css"   = "text/css"
        "js"    = "application/javascript"
        "png"   = "image/png"
        "svg"   = "image/svg+xml"
        "ico"   = "image/x-ico"
        "html"  = "text/html"
        "woff"  = "font/woff"
        "woff2" = "font/woff2"
        default = "application/octet-stream"
      }[split(".", b2c_file_path)[1]]
    }
  }

  b2c_files          = { for k, v in local.b2c_file_details : k => v }
  b2c_container_name = "${var.product}-b2c-container"
  containers = [{
    name        = local.b2c_container_name
    access_type = "container"
  }]
}

output "b2c_files" {
  value = local.b2c_files
}
