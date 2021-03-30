import mariadb
import uuid

class MariaDB_Base:
    def __init__(self):
        self.port = 5342
        self.host = "127.0.0.1"
        self.conn = None

    def connect_to_database(self):
        try:
            conn = mariadb.connect(
                user="root",
                password="admin123",
                host=self.host,
                port=self.port,
                database="Plants_Reminder"
            )

        except mariadb.Error as e:
            print("Napaka pri povezavi na bazo")
            print("{}".format(e))
            return False
        return True
    
    def register(self, email, username, password):
        cur = conn.cursor()

        try:
            cur.callproc('registerUser', (email, username, password, str(uuid.uuid4())))
        
        except mariadb.Error as e: 
            print("Napaka pri registraciji")
            print("{}".format(e))
            #cur.close()
            return False

        #cur.close()
        return True


    def login(self, username_or_email, password):
        cur = conn.cursor()
        try:
            cur.callproc('loginUser', (username_or_email, password))
        
        except mariadb.Error as e: 
            print("Napaka pri prijavi")
            print("{}".format(e))
            #cur.close()
            return False

        
        #cur.close()
        return True


    def close_connection():
        conn.close()
