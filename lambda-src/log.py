import logging
import logging.config
import yaml
from os import path



def setup_custom_logger(name):
  log_file_path = path.join(path.dirname(path.abspath(__file__)), 'logging.yml')
  with open(log_file_path, 'r') as stream:
    config = yaml.load(stream, Loader=yaml.FullLoader)
  logging.config.dictConfig(config)
  logger = logging.getLogger(name)
  return logger
