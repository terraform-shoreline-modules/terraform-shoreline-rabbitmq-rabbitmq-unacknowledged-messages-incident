bash

#!/bin/bash



# Set the RabbitMQ queue name

QUEUE_NAME=${RABBITMQ_QUEUE_NAME}



# Set the new RabbitMQ queue size

NEW_QUEUE_SIZE=${NEW_QUEUE_SIZE}



# Increase the RabbitMQ queue size

rabbitmqctl set_queue_size $QUEUE_NAME $NEW_QUEUE_SIZE



# Restart the RabbitMQ service

systemctl restart rabbitmq-server