resource "shoreline_notebook" "rabbitmq_unacknowledged_messages_incident" {
  name       = "rabbitmq_unacknowledged_messages_incident"
  data       = file("${path.module}/data/rabbitmq_unacknowledged_messages_incident.json")
  depends_on = [shoreline_action.invoke_change_queue_size,shoreline_action.invoke_rabbitmq_configure_dead_letter_queue_ttl]
}

resource "shoreline_file" "change_queue_size" {
  name             = "change_queue_size"
  input_file       = "${path.module}/data/change_queue_size.sh"
  md5              = filemd5("${path.module}/data/change_queue_size.sh")
  description      = "Increase the RabbitMQ queue size to accommodate the high number of unacknowledged messages temporarily."
  destination_path = "/tmp/change_queue_size.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "rabbitmq_configure_dead_letter_queue_ttl" {
  name             = "rabbitmq_configure_dead_letter_queue_ttl"
  input_file       = "${path.module}/data/rabbitmq_configure_dead_letter_queue_ttl.sh"
  md5              = filemd5("${path.module}/data/rabbitmq_configure_dead_letter_queue_ttl.sh")
  description      = "Configure RabbitMQ to automatically move unacknowledged messages to a dead-letter queue after a specified period for later reprocessing."
  destination_path = "/tmp/rabbitmq_configure_dead_letter_queue_ttl.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_change_queue_size" {
  name        = "invoke_change_queue_size"
  description = "Increase the RabbitMQ queue size to accommodate the high number of unacknowledged messages temporarily."
  command     = "`chmod +x /tmp/change_queue_size.sh && /tmp/change_queue_size.sh`"
  params      = ["RABBITMQ_QUEUE_NAME","QUEUE_NAME","NEW_QUEUE_SIZE"]
  file_deps   = ["change_queue_size"]
  enabled     = true
  depends_on  = [shoreline_file.change_queue_size]
}

resource "shoreline_action" "invoke_rabbitmq_configure_dead_letter_queue_ttl" {
  name        = "invoke_rabbitmq_configure_dead_letter_queue_ttl"
  description = "Configure RabbitMQ to automatically move unacknowledged messages to a dead-letter queue after a specified period for later reprocessing."
  command     = "`chmod +x /tmp/rabbitmq_configure_dead_letter_queue_ttl.sh && /tmp/rabbitmq_configure_dead_letter_queue_ttl.sh`"
  params      = ["DEAD_LETTER_QUEUE_NAME","QUEUE_NAME","ACK_TIME_LIMIT"]
  file_deps   = ["rabbitmq_configure_dead_letter_queue_ttl"]
  enabled     = true
  depends_on  = [shoreline_file.rabbitmq_configure_dead_letter_queue_ttl]
}

