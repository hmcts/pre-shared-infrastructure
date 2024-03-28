# resource "local_file" "template_html" {
#   filename = "b2c/views/template.html"
#   content = templatefile("b2c/views/template.html", {
#     env           = var.env
#     env_long_name = local.env_long_name
#   })
# }

# data "local_file" "main_css" {
#   filename = "b2c/views/css/main.css"
#   content = templatefile("b2c/views/css/main.css", {
#     env           = var.env
#     env_long_name = local.env_long_name
#   })
# }

# resource "local_file" "govuk_frontend_css" {
#   filename = "b2c/views/css/govuk-frontend-5.2.0.min.css"
#   content = templatefile("b2c/views/css/govuk-frontend-5.2.0.min.css", {
#     env           = var.env
#     env_long_name = local.env_long_name
#   })
# }

# resource "local_file" "b2c_js" {
#   filename = "b2c/views/js/b2c.js"
#   content = templatefile("b2c/views/js/b2c.js", {
#     env           = var.env
#     env_long_name = local.env_long_name
#   })
# }