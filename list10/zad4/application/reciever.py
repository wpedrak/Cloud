import pika

QUEUE_NAME = 'requests'
HOST = 'localhost'
PORT = '5672'

connection = pika.BlockingConnection(pika.ConnectionParameters(
    host=HOST,
    port=PORT))
channel = connection.channel()
channel.queue_declare(queue=QUEUE_NAME)

def callback(ch, method, properties, body):
    print("Received:", body)

channel.basic_consume(callback,
                      queue=QUEUE_NAME,
                      no_ack=True)

print('Waiting for messages. To exit press CTRL+C')
channel.start_consuming()