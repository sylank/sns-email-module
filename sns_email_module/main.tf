resource "aws_sns_topic" "email_topic" {
  name = "${var.email_topic_name}"
}

resource "aws_sqs_queue" "letter_queue" {
  name = "${var.letter_queue_name}"
}

resource "aws_sns_topic_subscription" "letter_queue_subscription" {
  topic_arn = "${aws_sns_topic.email_topic.arn}"
  protocol  = "sqs"
  endpoint  = "${aws_sqs_queue.letter_queue.arn}"
}

resource "aws_sns_topic_subscription" "email_subscription" {
  topic_arn = "${aws_sns_topic.email_topic.arn}"
  protocol  = "sqs"
  endpoint  = "${var.email_address}"
}