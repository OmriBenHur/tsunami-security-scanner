# sns topic to notify each time a file gets uploaded to the s3 bucket housing the joined security report
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

# creating the bucket to house the report
resource "aws_s3_bucket" "report_bucket" {
  bucket = "security-reports131"
}

# creating a bucket notification object to use with sns
resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.report_bucket.id

  topic {
    topic_arn = aws_sns_topic.s3_push.arn
    events    = ["s3:ObjectCreated:*"]
  }
}

# sns topic subscription to send an email to the predifined email address from the "vars.tf" file
resource "aws_sns_topic_subscription" "s3_uploaded_file" {
  topic_arn = aws_sns_topic.s3_push.arn
  protocol  = "email"
  endpoint  = var.email_address
}