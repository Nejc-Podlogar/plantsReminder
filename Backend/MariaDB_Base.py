import mariadb
import uuid

class MariaDB_Base:
    def __init__(self):
        self.port = 5342
        self.host = "127.0.0.1"
        self.conn = None

    def connect_to_database(self):
        try:
            self.conn = mariadb.connect(
                user="root",
                password="admin123",
                host=self.host,
                port=self.port,
                database="plantsreminder"
            )

        except mariadb.Error as e:
            print("Napaka pri povezavi na bazo")
            print("{}".format(e))
            return False
        return True
    
    def register(self, email, username, password):
        ret = {}
        cur = self.conn.cursor()

        try:
            cur.callproc('registerUser', (email, username, password, str(uuid.uuid4())))
            self.conn.commit()
            print("reg res:".format(cur.fetchall()))
        
        except mariadb.Error as e: 
            print("Napaka pri registraciji")
            ret['success'] = False
            if (e.errno == 1062):
                ret['error'] = 'Uporabnik s tem uporabniškim imenom obstaja'
            else:
                ret['error'] = 'Napaka pri registraciji'
            return ret

        ret['success'] = True
        return ret


    def login(self, username_or_email, password):
        ret = {}
        cur = self.conn.cursor()
        try:
            cur.callproc('loginUser', (username_or_email, password, 1))
            #print("Fetch one: {}".format(cur.fetchone()))

            proc_res = cur.fetchone()
            if (len(proc_res) == 0 or proc_res[0] == 0):
                ret['error'] = 'Uporabnik ni najden'
                ret['success'] = False
                return ret
        
        except mariadb.Error as e: 
            print("Napaka pri prijavi")
            print("{}".format(e))
            ret['error'] = 'Napaka pri prijavi'
            ret['success'] = False
            return ret

        
        ret['success'] = True
        return ret

    def allPlants(self, user):
        ret= {}
        cur = self.conn.cursor()
        try:
            cur.callproc('')

            proc_res = cur.fetchall()

            ret['success'] = True

            plants = []
            for res in proc_res:
                plant = {}
                plant['name'] = res[0]
                plant['description'] = res[1]
                plant['image'] = res[2]
                plant['lat_name'] = res[3]
                plants.append(plant)

            return ret

        except mariadb.Error as e: 
            print("Napaka pri pridobivanju rastlin")
            print("{}".format(e))
            ret['error'] = 'Napaka pri pridobivanju rastlin'
            ret['success'] = False
            return ret


    def close_connection(self):
        self.conn.close()
