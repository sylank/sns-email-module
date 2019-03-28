output "topic_arn" {
  value = "${aws_sns_topic.email_topic.arn}"
}