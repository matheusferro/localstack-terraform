import boto3
import log
import json
from datetime import datetime
from dateutil.relativedelta import relativedelta
from botocore.config import Config
import uuid

def lambda_handler(event, context):
  logger = log.setup_custom_logger('lambdaLogger')


  # my_config = Config(
  #     region_name = 'us-east-1',
  #     signature_version = 'v4',
  #     retries = {
  #         'max_attempts': 10,
  #         'mode': 'standard'
  #     }
  # )
  sfn_client = boto3.client('stepfunctions',
  endpoint_url='http://localhost:4566'
  # ,   
  #   aws_access_key_id='test',
  #   aws_secret_access_key='test',
  #   verify=False
  )
  # sfn_client = boto3.client('stepfunctions', config=my_config)
  date_format_str = '%Y-%m-%dT%H:%M:%SZ'
  oneMinute = (datetime.now() + relativedelta(minutes=1)).strftime(date_format_str)

  # response = sfn_client.start_execution(
  #   stateMachineArn= 'arn:aws:states:us-east-1:000000000000:stateMachine:state-machine-sfn',
  #   name=str(uuid.uuid4()),
  #   input=json.dumps({ 'sendTimestamp': oneMinute })
  # )

  response = { 'sendTimestamp': oneMinute }
  logger.info(f'- {response}')
  return {
    'statusCode': 200,
    'body': response
  }

lambda_handler({}, {})