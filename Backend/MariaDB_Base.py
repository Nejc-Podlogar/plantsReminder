import mariadb
import uuid

class MariaDB_Base:
    def __init__(self):
        self.port = 3306
        self.host = "127.0.0.1"
        self.conn = None

    def connect_to_database(self):
        try:
            self.conn = mariadb.connect(
                user="root",
                password="ynpXyi2NmKARwX",
                host=self.host,
                port=self.port,
                database="plants_reminder"
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

    def allUserPlants(self, username):
        ret= {}
        cur = self.conn.cursor()
        try:
            sql = "Select * from plants AS p INNER JOIN plants_users pu ON p.id = pu.fk_plants INNER JOIN users u ON u.id = pu.fk_users WHERE u.username = '{}'".format(str(username))
            cur.execute(sql)

            ret['success'] = True

            plants = []
            for res in cur:
                plant = {}
                plant['id'] = res[0]
                plant['name'] = res[1]
                plant['latin_name'] = res[2]
                plant['description'] = res[3]
                plant['watering_period'] = res[4]
                plant['watering_amount'] = res[5]
                plant['link_wiki'] = res[6]
                plant['slika'] = res[7]
                plants.append(plant)

            ret['plants'] = plants
            return ret

        except mariadb.Error as e: 
            print("Napaka pri pridobivanju rastlin")
            print("{}".format(e))
            ret['error'] = 'Napaka pri pridobivanju rastlin'
            ret['success'] = False
            return ret


    def allPlants(self):
        ret= {}
        cur = self.conn.cursor()
        try:
            sql = "Select * from plants"

            cur.execute(sql)

            plants=[]

            for res in cur:
                plant = {}
                plant['id'] = res[0]
                plant['name'] = res[1]
                plant['latin_name'] = res[2]
                plant['description'] = res[3]
                plant['watering_period'] = res[4]
                plant['watering_amount'] = res[5]
                plant['link_wiki'] = res[6]
                plant['link_slika'] = res[7]
                plants.append(plant)

            ret['plants'] = plants
            return ret

        except mariadb.Error as e: 
            print("Napaka pri pridobivanju rastlin")
            print("{}".format(str(e)))
            ret['error'] = 'Napaka pri pridobivanju rastlin'
            ret['success'] = False
            return ret

    def close_connection(self):
        self.conn.close()
