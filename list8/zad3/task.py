from google.cloud import storage, pubsub_v1

import time

PROJECT_ID = "tmp1"
BUCKET_NAME = "tmp2"
SUBSCRIPTION_NAME = "tmp3"

def upload_blob(source_file_name, destination_blob_name):
    """Uploads a file to the bucket."""
    storage_client = storage.Client()
    bucket = storage_client.get_bucket(BUCKET_NAME)
    blob = bucket.blob(destination_blob_name)
    blob.upload_from_filename(source_file_name)
    print('File {} uploaded to {}.'.format(
        source_file_name,
        destination_blob_name))


def write_result(result, result_filename):
    NAME = result_filename
    file = open(result_filename, 'w')
    file.write(', '.join(result))
    file.close()
    upload_blob(result_filename, result_filename)


def parse_message(message):
    return [int(x) for x in split(message)]

def is_prime(number):
    return not any([number % x == 0 for x in range(2,number)])

def find_primes(range_from, range_to):
    return [x for x in range(range_from, range_to) if is_prime(x)]


def callback(message):
    print('Received message: {}'.format(message))
    range_from, range_to = parse_message(message)
    result = find_primes(range_from, range_to)
    result_filename = "result-from-{}-to-{}.txt".format(range_from, range_to)
    write_result(result, result_filename)
    message.ack()


subscriber = pubsub_v1.SubscriberClient()
# The `subscription_path` method creates a fully qualified identifier
# in the form `projects/{PROJECT_ID}/subscriptions/{SUBSCRIPTION_NAME}`
subscription_path = subscriber.subscription_path(PROJECT_ID, SUBSCRIPTION_NAME)
subscriber.subscribe(subscription_path, callback=callback)

# The subscriber is non-blocking. We must keep the main thread from
# exiting to allow it to process messages asynchronously in the background.
print('Listening for messages on {}'.format(subscription_path))
while True:
    time.sleep(60)


upload_blob("result-holder", 'tmp.txt', 'result.txt')
