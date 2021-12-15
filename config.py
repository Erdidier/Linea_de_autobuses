import os

class Config(object):
	SECRET_KEY = 'my_secret_key'

class DevelopmentConfig(Config):
	DEBUG = True
	#SQLALCHEMY_DATABASE_URI = 'mysql://root:Erdidier137980@flask.c0dsfverhxrf.us-east-1.rds.amazonaws.com/flask'
	SQLALCHEMY_DATABASE_URI = 'mysql://root:Erdidier137980@localhost/flask'
	SQLALCHEMY_TRACK_MODIFICATIONS = False