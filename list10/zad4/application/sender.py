import pika
import sys

QUEUE_NAME = 'requests'
HOST = 'localhost'
PORT = '5672'

connection = pika.BlockingConnection(pika.ConnectionParameters(
    host=HOST,
    port=PORT
))
channel = connection.channel()
channel.queue_declare(queue=QUEUE_NAME)

range_from, range_to = sys.argv[1], sys.argv[2]

body = f"{range_from} {range_to}"

channel.basic_publish(exchange='',
                      routing_key=QUEUE_NAME,
                      body=body)
print("Sent:", body)
connection.close()
