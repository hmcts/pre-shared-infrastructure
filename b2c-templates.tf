locals {
  b2c_file_paths = fileset(path.module, "b2c/views/**")
  b2c_file_details = {
    for b2c_file_path in local.b2c_file_paths :
    basename(b2c_file_path) => {
      name        = basename(b2c_file_path)
      file_name   = b2c_file_path
      content_md5 = filemd5("${path.module}/${b2c_file_path}")
      path        = "${path.module}/${b2c_file_path}"
      content = replace(replace(filebase64("${path.module}/${b2c_file_path}"),
        "{env}", var.env),
      "{env_long_name}", local.env_long_name)
      content_type = (split(".", b2c_file_path)[1] == "css" ? "text/css" :
        split(".", b2c_file_path)[1] == "js" ? "application/javascript" :
        split(".", b2c_file_path)[1] == "png" ? "image/png" :
        split(".", b2c_file_path)[1] == "svg" ? "image/svg+xml" :
        split(".", b2c_file_path)[1] == "ico" ? "image/vnd.microsoft.icon" :
        split(".", b2c_file_path)[1] == "html" ? "text/html" :
        split(".", b2c_file_path)[1] == "xml" ? "application/xml" :
        split(".", b2c_file_path)[1] == "woff" ? "font/woff" :
        split(".", b2c_file_path)[1] == "woff2" ? "font/woff2" :
      "application/octet-stream")
    }
  }
  b2c_files = { for k, v in local.b2c_file_details : k => v }

  b2c_container_name = "${var.product}-b2c-container"
  containers = [{
    name        = local.b2c_container_name
    access_type = "container"
  }]
}

output "b2c_files" {
  value = local.b2c_files
}
