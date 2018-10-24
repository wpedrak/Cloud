import boto3
import time
from fabric import Connection
# from invoke import Responder
ec2 = boto3.resource('ec2')


def get_instance_info(instance_id):
    global ec2
    return  list(ec2.instances.filter(InstanceIds=[instance_id]))[0]

def wait_for_instance_to_run(instance_id):
    while True:
        current_instance_info = get_instance_info(instance_id)
        # print(current_instance_info.state)
        if current_instance_info.state["Name"] == "running":
            return current_instance_info
        time.sleep(1)

def execute_commands_on_linux_instances(instance_ip, commands):
    c = Connection(
        host=instance_ip, 
        user='ubuntu', 
        connect_kwargs={'key_filename': '../../cloud2018.pem'}
    )
    # r = Responder(
    #     pattern=r'Do you want to continue? \[Y/n\]',
    #     response="y\n",
    # )

    for command in commands:
        print(command)
        result = c.run(command, hide=True) #watchers=[r]
        # print('Result:', result)
    # return resp

# ami id for us-west-2
instances = ec2.create_instances(
    ImageId='ami-0bbe6b35405ecebdb', # ubuntu 18.04
    InstanceType='t2.micro', 
    MinCount=1, 
    MaxCount=1,
    KeyName='cloud2018',
    SecurityGroups=['launch-wizard-3'] # allow ssh and HTTP
)

instance = instances[0]
print("Started creation of instance of id:", instance.id)

instance = wait_for_instance_to_run(instance.id)
print("Instance created.")
print("Public IPv4: ", instance.public_ip_address)

commands = [
    'sudo apt-get update',
    'sudo apt-get -y install apache2',
    'sudo chown -R ubuntu /var/www/html',
    'sudo chmod -R g+rw /var/www/html',
    'echo "<h1>Static Site</h1>" > /var/www/html/index.html',
]

print("Runing commands via SSH...")
execute_commands_on_linux_instances(instance.public_ip_address, commands)
print("All commands finished")

print("Creating Image from instance...")
instance.create_image(Name='static_server')
print("Image created.")