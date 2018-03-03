## imports
import os
import yaml
from sqlalchemy import create_engine
from sqlalchemy.engine.url import URL
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker, scoped_session
from orm.models import *

with open('conf/config.yml', 'r') as f:
  settings = yaml.load(f)

def db_connect():
    """
    Connects to the database
    """
    url = URL(**settings['postgres'])
    return create_engine(url, echo=settings['pg_echo'], client_encoding='utf8')

def create_tables(engine, base):
    """
    Creates or maps the tables in the database
    """
    base.metadata.create_all(engine)

def create_session(base):
    """
    Returns a queryable session
    """
    engine = db_connect()
    create_tables(engine, base)
    Session = scoped_session(sessionmaker(bind=engine))
    base.query = Session.query_property()
    
    return(Session())

