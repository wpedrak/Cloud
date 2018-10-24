#! /usr/bin/python3
import sys
import boto3
import time
from fabric import Connection
ec2 = boto3.resource('ec2')


def get_instance_info(instance_id):
    global ec2
    return  list(ec2.instances.filter(InstanceIds=[instance_id]))[0]

def wait_for_instance_to_run(instance_id, timeout=999):
    for _ in range(timeout):
        current_instance_info = get_instance_info(instance_id)
        # print(current_instance_info.state)
        if current_instance_info.state["Name"] == "running":
            return current_instance_info
        time.sleep(1)
    return False

def create_insrances(number_of_instances):
    instances = ec2.create_instances(
        ImageId='ami-7d482305', # ubuntu 16.04 with python, ami id for us-west-2
        InstanceType='t2.micro', 
        MinCount=number_of_instances, 
        MaxCount=number_of_instances,
        KeyName='cloud2018',
        SecurityGroups=['launch-wizard-3'] # allow ssh and HTTP
    )
    print("created", number_of_instances, "instances. Waiting for 'running' state.")
    ips = []
    for instance in instances:
        instance = wait_for_instance_to_run(instance.id, timeout=60)
        print("id, ip =", instance.id, instance.public_ip_address)
        ips.append(instance.public_ip_address)
    
    print("IPs for easy copy-paste")
    for ip in ips:
        print(ip)

if __name__ == '__main__':
    create_insrances(int(sys.argv[1]))