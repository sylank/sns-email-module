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

resource "null_resource" "sns_subscribe" {
  depends_on = ["aws_sns_topic.email_topic"]

  triggers = {
    sns_topic_arn = "${aws_sns_topic.email_topic.arn}"
  }

  count = "${length(var.email_address_list)}"

  provisioner "local-exec" {
    command = "aws sns subscribe --topic-arn ${aws_sns_topic.email_topic.arn} --protocol email --notification-endpoint ${element(var.email_address_list, count.index)}"
  }
}
