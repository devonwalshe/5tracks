import yaml
from elasticsearch import Elasticsearch
import psycopg2
import os
from orm.models import *
from orm.orm import create_session

with open('conf/config.yml', 'r') as f:
  settings = yaml.load(f)

es = Elasticsearch(["http://{}:{}@{}:{}".format(settings['elasticsearch']['user'], 
                                                os.environ[settings['elasticsearch']['password']],
                                                settings['elasticsearch']['host'],
                                                settings['elasticsearch']['port'])])

pg_connection_string = "dbname={} user={} password={}".format(settings['postgres']['database'],
                                       settings['postgres']['username'],
                                       settings['postgres']['port'],
                                       settings['postgres']['password'])
                                       
session = create_session(Base)
