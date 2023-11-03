

#!/bin/bash



# Set the queue name and dead-letter queue name

QUEUE_NAME=${QUEUE_NAME}

DEAD_LETTER_QUEUE_NAME=${DEAD_LETTER_QUEUE_NAME}



# Set the time limit for message acknowledgement in seconds

ACK_TIME_LIMIT=${ACK_TIME_LIMIT}



# Enable the dead-lettering feature on the queue

rabbitmqctl set_policy DLX "^${QUEUE_NAME}$" '{"dead-letter-exchange":"", "dead-letter-routing-key":"'${DEAD_LETTER_QUEUE_NAME}'"}' --apply-to queues



# Set the time-to-live (TTL) value for messages in the queue

rabbitmqctl set_queue_ttl ${QUEUE_NAME} ${ACK_TIME_LIMIT}000



echo "RabbitMQ has been configured to automatically move unacknowledged messages to the dead-letter queue after ${ACK_TIME_LIMIT} seconds."