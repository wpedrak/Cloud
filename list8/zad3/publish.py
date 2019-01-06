from google.cloud import pubsub_v1

PROJECT_ID = "Your Google Cloud Project ID"
TOPIC_NAME = "Your Pub/Sub topic name"

publisher = pubsub_v1.PublisherClient()
# The `topic_path` method creates a fully qualified identifier
# in the form `projects/{PROJECT_ID}/topics/{TOPIC_NAME}`
topic_path = publisher.topic_path(PROJECT_ID, TOPIC_NAME)

for n in range(1, 2):
    data = u'Message number {}'.format(n)
    # Data must be a bytestring
    data = data.encode('utf-8')
    # When you publish a message, the client returns a future.
    future = publisher.publish(topic_path, data=data)
    print('Published {} of message ID {}.'.format(data, future.result()))

print('Published messages.')