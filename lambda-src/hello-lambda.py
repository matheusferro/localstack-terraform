import boto3
import log

# logger = log.setup_custom_logger('lambdaLogger')

def lambda_handler(event, context):
  logger = log.setup_custom_logger('lambdaLogger')
  response = f'Hello!! called by: {event["job"]}'
  logger.info(f'- {response}')
  return {
    'statusCode': 200,
    'body': response
  }