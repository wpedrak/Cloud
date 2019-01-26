import pika

QUEUE_NAME = 'requests'
HOST = 'localhost'
PORT = '5672'

connection = pika.BlockingConnection(pika.ConnectionParameters(
    host=HOST,
    port=PORT))
channel = connection.channel()
channel.queue_declare(queue=QUEUE_NAME)


def parse_message(message):
    text = message.data.decode('utf-8')
    return [int(x) for x in text.split()]


def is_prime(number):
    if number < 2:
        return False
    return all([number % x != 0 for x in range(2, number)])


def find_primes(range_from, range_to):
    return [x for x in range(range_from, range_to) if is_prime(x)]


def write_result(result):
    print(result)


def callback(ch, method, properties, body):
    message = body
    print("Received:", body)
    range_from, range_to = parse_message(message)
    result = find_primes(range_from, range_to)

    write_result(result)


channel.basic_consume(callback,
                      queue=QUEUE_NAME,
                      no_ack=True)

print('Waiting for messages. To exit press CTRL+C')
channel.start_consuming()
