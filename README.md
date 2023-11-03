
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# RabbitMQ Unacknowledged Messages Incident
---

This incident type involves a high number of unacknowledged messages in RabbitMQ queues. RabbitMQ is a message broker that is utilized to handle the communication between software applications. When a message is sent to RabbitMQ queue, it is expected to be acknowledged by the recipient. However, if the message remains unacknowledged for a long time, it can cause the number of unacknowledged messages in the queue to increase significantly. This can lead to performance issues and impact the overall functionality of the software system.

### Parameters
```shell
export NEW_QUEUE_SIZE="PLACEHOLDER"

export RABBITMQ_QUEUE_NAME="PLACEHOLDER"

export ACK_TIME_LIMIT="PLACEHOLDER"

export QUEUE_NAME="PLACEHOLDER"

export DEAD_LETTER_QUEUE_NAME="PLACEHOLDER"
```

## Debug

### Check RabbitMQ server status
```shell
sudo systemctl status rabbitmq-server
```

### Check RabbitMQ server logs
```shell
sudo journalctl -u rabbitmq-server --no-pager
```

### Check RabbitMQ queues status
```shell
sudo rabbitmqctl list_queues
```

### Check RabbitMQ queues with high number of unacknowledged messages
```shell
sudo rabbitmqctl list_queues name messages_unacknowledged
```

### Check RabbitMQ connections status
```shell
sudo rabbitmqctl list_connections
```

### Check RabbitMQ channels status
```shell
sudo rabbitmqctl list_channels
```

### Check RabbitMQ consumers status
```shell
sudo rabbitmqctl list_consumers
```

### Check RabbitMQ message rate
```shell
sudo rabbitmqctl list_queues name messages message_stats.publish_details.rate
```

## Repair

### Increase the RabbitMQ queue size to accommodate the high number of unacknowledged messages temporarily.
```shell
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


```

### Configure RabbitMQ to automatically move unacknowledged messages to a dead-letter queue after a specified period for later reprocessing.
```shell


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


```