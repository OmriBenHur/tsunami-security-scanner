resource "aws_sns_topic" "s3_push" {
  name = "s3-event-notification-topic"

  policy = <<POLICY
{
    "Version":"2012-10-17",
    "Statement":[{
        "Effect": "Allow",
        "Principal": { "Service": "s3.amazonaws.com" },
        "Action": "SNS:Publish",
        "Resource": "arn:aws:sns:*:*:s3-event-notification-topic",
        "Condition":{
            "ArnLike":{"aws:SourceArn":"${aws_s3_bucket.report_bucket.arn}"}
        }
    }]
}
POLICY
}

resource "aws_s3_bucket" "report_bucket" {
  bucket = "security-reports131"
}


resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.report_bucket.id

  topic {
    topic_arn = aws_sns_topic.s3_push.arn
    events    = ["s3:ObjectCreated:*"]
  }
}
resource "aws_sns_topic_subscription" "s3_uploaded_file" {
  topic_arn = aws_sns_topic.s3_push.arn
  protocol  = "email"
  endpoint  = var.email_address
}