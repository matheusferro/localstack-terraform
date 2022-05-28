import boto3
from datetime import datetime
import logging
import time

LOGGER = logging.getLogger()
LOGGER.setLevel(logging.INFO)

def lambda_handler(event, context):
  response = f'Hello!! called by: {event["job"]}'
  LOGGER.info(f'{datetime.now()} - Response: {response} ')
  print(f'{datetime.now()} - Response: {response} ')
  return {
    'statusCode': 200,
    'body': response
  }