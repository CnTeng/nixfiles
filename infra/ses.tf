resource "aws_ses_domain_identity" "smtp" {
  domain = "snakepi.eu.org"
}
resource "aws_ses_domain_dkim" "smtp" {
  domain = aws_ses_domain_identity.smtp.domain
}
