resource "aws_kms_key" "kms_key" {
   description = "KMS key"
   deletion_window_in_days = 30 
}