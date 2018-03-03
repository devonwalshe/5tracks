import psycopg2
import psycopg2.extras

class PgConn(object):
  
  def __init__(self, conn_string, itersize=1000, arraysize=1000):
    self.conn = psycopg2.connect(conn_string)
    self.itersize=itersize
    self.arraysize=arraysize

  def connect(self):
    connection = psycopg2.connect(self.conn_string)
    self.conn = connection
    return(self.conn)

  def cursor(self, connection = None):
    if not connection:
      connection = self.conn
    return(connection.cursor())
    
  def named_cursor(self, name, dict_cursor=True, connection = None):
    if not connection:
      connection = self.conn
    if dict_cursor:
      cursor = connection.cursor(name, cursor_factory=psycopg2.extras.RealDictCursor)
    else:
      cursor = connection.cursor(name)
    cursor.arraysize = self.arraysize
    cursor.itersize = self.itersize
    return(cursor)
    