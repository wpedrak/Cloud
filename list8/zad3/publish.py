from google.cloud import pubsub_v1
from math import sqrt

PROJECT_ID = "cloud2018-list2"
TOPIC_NAME = "topic-8-3"

publisher = pubsub_v1.PublisherClient()
# The `topic_path` method creates a fully qualified identifier
# in the form `projects/{PROJECT_ID}/topics/{TOPIC_NAME}`
topic_path = publisher.topic_path(PROJECT_ID, TOPIC_NAME)

NUMBER_OF_TASKS = 10
MAGIC_NUMBER = 5e8
range_left = 1


for i in range(NUMBER_OF_TASKS):
    range_right = int(sqrt(MAGIC_NUMBER + range_left * range_left))
    data = u'{} {}'.format(range_left, range_right)
    range_left = range_right
    # Data must be a bytestring
    data = data.encode('utf-8')
    # When you publish a message, the client returns a future.
    future = publisher.publish(topic_path, data=data)
    print('Published {} of message ID {}.'.format(data, future.result()))

print('Published messages.')