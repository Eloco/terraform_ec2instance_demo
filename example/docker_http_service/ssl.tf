resource "aws_acm_certificate" "local_cert" {
  domain_name       = "*"
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}
