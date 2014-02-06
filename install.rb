require 'sequel'

DB = Sequel.connect('sqlite://application.db')
# make a new table for posts
DB.run('CREATE TABLE posts(id INTEGER PRIMARY KEY AUTOINCREMENT, time TEXT,name TEXT(10), msg TEXT(140))')