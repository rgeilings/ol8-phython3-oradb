#! /usr/bin/python3
import oracledb
import sys

SEPARATOR = '|'
LINE_SEPARATOR = '\n'

# Initializing Oracle (thick) client
oracledb.init_oracle_client()

# List of database credentials
# e.g.     {"user": "system", "password": "verysecret2024!", "dsn": "localhost:1521/ORCL", "sid":"ORCL"}
databases = [
    {"user": "system", "password": "<<password here>>", "dsn": "<<hostname here>>:<<listener port here>>/<<sid here>>", "sid":"<<sid here>>"},
    {"user": "system", "password": "<<password here>>", "dsn": "<<hostname here>>:<<listener port here>>/<<sid here>>", "sid":"<<sid here>>"},
    {"user": "system", "password": "<<password here>>", "dsn": "<<hostname here>>:<<listener port here>>/<<sid here>>", "sid":"<<sid here>>"}
]

def die(msg=None):
    sys.stderr.write('{0}\n'.format(msg))
    sys.exit(1)


def usage():
    print("""Usage {0} "QUERY"
    """.format(os.path.basename(sys.argv[0])))

def main(query):
    for database in databases:
        try:
            db = oracledb.connect(user=database["user"], password=database["password"], dsn=database["dsn"])
            cursor = db.cursor()
            cursor.execute(query) 

            rows = cursor.fetchall()

            for row in rows:
                sys.stdout.write("{0}{1}".format(database['sid'], SEPARATOR))

                for col in row:
                    sys.stdout.write("{0}".format(col))
                    sys.stdout.write(SEPARATOR)

                sys.stdout.write(LINE_SEPARATOR)

            cursor.close()
            db.close()
            
        except KeyboardInterrupt as e:
            return
        except Exception as e:
            print(f"Could not connect to database {database['sid']}: {e}")
            continue

if __name__ == '__main__':
    if len(sys.argv) < 1 or len(sys.argv) > 2:
        usage()
        die("Invalid number of arguments.")

    elif len(sys.argv) == 1:
        #query = sys.argv[1]
        query = ''.join(sys.stdin).strip()
        main(query)

    elif len(sys.argv) == 2:
        database = sys.argv[1].upper()
        #query = sys.argv[2]
        query = ''.join(sys.stdin).strip()
        # print(query)
        main(query, database)

    try:
        sys.stdout.flush() 
    except IOError:
        pass
