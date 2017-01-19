#!/usr/bin/env python

"""
Usage:
  migrate-elb-subnets.py

"""

import boto3
import json
import os
import sys
from botocore.exceptions import ClientError
import pdb

elb_client = boto3.client('elb')
cf_client = boto3.client('cloudformation')
ec2_client = boto3.resource('ec2')


def main():

    if 'STACK_INPUTS' in os.environ:
        pass
    else:
        print('Script expect environment variable STACK_INPUTS to be set')
        sys.exit(1)

    json_stack = json.loads(os.environ['STACK_INPUTS'])

    try:
        stack = cf_client.describe_stack_resources(StackName=json_stack['name'])['StackResources']
    except ClientError: 
        print('Stack doesnt exist - nothing to migrate')
        sys.exit(0)        

    for stac in stack:
        if stac['LogicalResourceId'] == 'LoadBalancer':
            elb_name = stac['PhysicalResourceId']
            break

    elb_object = elb_client.describe_load_balancers(LoadBalancerNames=[elb_name])['LoadBalancerDescriptions'][0]
    current_elb_subnets = sorted(elb_object['Subnets'])
    new_elb_subnets = sorted(json_stack['parameters']['subnets'].split(','))

    print("Current subnets:")
    print(current_elb_subnets)
    print("New subnets:")
    print(new_elb_subnets)

    if current_elb_subnets == new_elb_subnets:
        print("No changes necessary")
        sys.exit(0)
    else:
        print("Migrating loadbalancer subnets")

    for c_elb in current_elb_subnets:
        az_to_change = return_subnet_az(c_elb)
        for n_elb in new_elb_subnets:
            if return_subnet_az(n_elb) == az_to_change:
                elb_client.detach_load_balancer_from_subnets(LoadBalancerName=elb_name, Subnets=[c_elb])
                elb_client.attach_load_balancer_to_subnets(LoadBalancerName=elb_name, Subnets=[n_elb])
                print("Switched ELB: " + elb_name + " in A/Z: " + az_to_change + " from Subnet ID: " + c_elb + " to Subnet ID: " + n_elb)



def return_subnet_az(subnet):
    return ec2_client.Subnet(subnet).availability_zone


if __name__ == '__main__':
    main()
