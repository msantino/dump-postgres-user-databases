# dump-postgres-user-databases


dump-postgres-user-databases.sh is a script to dump all user databases (excluding template0, template1, postgres, etc) from a given PostgreSQL connection. 

### Installation

It requires PostgreSQL binaries already installed and accessible via `$PATH`. 

Clone it under desired directory:

```sh
$ git clone https://github.com/msantino/dump-postgres-user-databases.git
$ cd dump-postgres-user-databases
$ sh dump-postgres-user-databases.sh PG-HOST LOGIN PATH-TO-DUMPS
```

`pg_dump` requires authentication, so to prevent password prompt for every database to dump, configure `.pgpass` under user home directory:

```sh
$ echo "your-postgres-host:5432:*:username:password" >> ~/.pgpass
$ chmod 0600 ~/.pgpass
$ sh dump-postgres-user-databases.sh PG-HOST LOGIN
```

License
----

MIT

