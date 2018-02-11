import yaml
from elasticsearch import Elasticsearch
import psycopg2
import os

def settings():
  with open('config.yml', 'r') as f:
    settings = yaml.load(f)
  return(settings)

settings = settings()

es = Elasticsearch(["http://{}:{}@{}:{}".format(settings['elasticsearch']['user'], 
                                                os.environ[settings['elasticsearch']['password']],
                                                settings['elasticsearch']['host'],
                                                settings['elasticsearch']['port'])])

pg_connection_string = "dbname={} user={} password={}".format(settings['postgres']['database'],
                                       settings['postgres']['user'],
                                       settings['postgres']['port'],
                                       settings['postgres']['password'])
                                       
