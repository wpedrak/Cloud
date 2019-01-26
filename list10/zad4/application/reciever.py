import pika

REQUEST_QUEUE = 'requests'
RESULT_QUEUE = 'results'
HOST = 'localhost'
PORT = '5672'

connection = pika.BlockingConnection(pika.ConnectionParameters(
    host=HOST,
    port=PORT))
channel = connection.channel()
channel.queue_declare(queue=REQUEST_QUEUE)
channel.queue_declare(queue=RESULT_QUEUE)


def put_in_result_queue(message):
    channel.basic_publish(exchange='',
                          routing_key=RESULT_QUEUE,
                          body=message)


def parse_message(message):
    text = message.decode('utf-8')
    return [int(x) for x in text.split()]


def is_prime(number):
    if number < 2:
        return False
    return all([number % x != 0 for x in range(2, number)])


def find_primes(range_from, range_to):
    return [x for x in range(range_from, range_to) if is_prime(x)]


def write_result(range_from, range_to, result):
    message = f"[{range_from} {range_to}]: " + ", ".join(map(str, result))
    put_in_result_queue(message)


def callback(ch, method, properties, body):
    message = body
    print("Received:", message)
    range_from, range_to = parse_message(message)
    result = find_primes(range_from, range_to)
    write_result(range_from, range_to, result)
    ch.basic_ack(delivery_tag=method.delivery_tag)
    print("processed")


channel.basic_consume(callback,
                      queue=REQUEST_QUEUE)

print('Waiting for messages. To exit press CTRL+C')
channel.start_consuming()
