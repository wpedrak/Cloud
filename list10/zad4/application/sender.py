import pika

QUEUE_NAME = 'requests'
HOST = 'localhost'
PORT = '5672'

connection = pika.BlockingConnection(pika.ConnectionParameters(
    host=HOST,
    port=PORT
))
channel = connection.channel()
channel.queue_declare(queue=QUEUE_NAME)

body = '1 2'

channel.basic_publish(exchange='',
                      routing_key=QUEUE_NAME,
                      body=body)
print("Sent:", body)
connection.close()
