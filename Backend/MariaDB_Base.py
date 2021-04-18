import mariadb
import uuid
import datetime
import hashlib

class MariaDB_Base:
    def __init__(self):
        #self.port = 3306
        self.port = 5342
        self.host = "127.0.0.1"
        self.conn = None

    def connect_to_database(self):
        try:
            self.conn = mariadb.connect(
                user="root",
                #password="ynpXyi2NmKARwX",
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
            row_guid_user = str(uuid.uuid4())

            cur.callproc('registerUser', (email, username, password, str(uuid.uuid4()), row_guid_user))
            self.conn.commit()
            #print("reg res:".format(cur.fetchall()))

            #ret['row_guid'] = row_guid_user
        
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
            cur.callproc('loginUser', (username_or_email, password, 1, 1))
            #print("Fetch one: {}".format(cur.fetchone()))

            proc_res = cur.fetchone()
            print(proc_res)
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
        ret['row_guid'] = proc_res[1]
        return ret


    def allUserPlants(self, row_guid):
        ret= {}
        cur = self.conn.cursor()
        try:
            sql = "Select p.id,p.name,p.latin_name,p.description,p.watering_period,p.watering_amount,p.link_wiki,p.slika, pu.id, pu.last_watering FROM plants AS p INNER JOIN plants_users pu ON p.id = pu.fk_plants INNER JOIN users u ON u.id = pu.fk_users WHERE u.row_guid = '{}'".format(str(row_guid))
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
                plant['pu_id'] = res[8]
                plant['last_watering'] = res[9].strftime('%d.%b.%Y')
                plant['must_water'] = True if (datetime.datetime.strptime(res[9].strftime('%d.%b.%Y'), '%d.%b.%Y') + datetime.timedelta(days=int(res[4]))).date() <= datetime.datetime.now().date() else False
                plants.append(plant)

            ret['success'] = True
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
                plant['slika'] = res[7]
                plants.append(plant)

            ret['success'] = True
            ret['plants'] = plants
            return ret

        except mariadb.Error as e: 
            print("Napaka pri pridobivanju rastlin")
            print("{}".format(str(e)))
            ret['error'] = 'Napaka pri pridobivanju rastlin'
            ret['success'] = False
            return ret


    def newUserPlant(self, row_guid, plant_id, last_watering):
        ret = {}
        cur = self.conn.cursor()
        
        try:
            sql = "SELECT id FROM users WHERE users.row_guid = '{}'".format(str(row_guid))
            cur.execute(sql)

            res = cur.fetchall()

            if (not cur or len(res) == 0):
                ret['success'] = False
                return ret

            print(res[0])

            sql = "INSERT INTO plants_users (fk_plants, fk_users, last_watering) VALUES ({}, {}, '{}');".format(int(plant_id), int(res[0][0]), last_watering)
            cur.execute(sql)
            self.conn.commit()

            ret['success'] = True
            return ret


        except mariadb.Error as e: 
            print("Napaka pri dodajanju nove rastline")
            print("{}".format(str(e)))
            ret['error'] = 'Napaka pri pridobivanju rastlin'
            ret['success'] = False
            return ret


    def updateLastWatering(self, id):
        ret = {}
        cur = self.conn.cursor()
        
        try:
            sql = "UPDATE plants_users SET last_watering = '{}' WHERE id = {};".format(datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S'), int(id))
            cur.execute(sql)
            self.conn.commit()

            ret['success'] = True
            return ret


        except mariadb.Error as e: 
            print("Napaka pri updatu dneva zalivanja")
            print("{}".format(str(e)))
            ret['error'] = 'Napaka pri pridobivanju rastlin'
            ret['success'] = False
            return ret


    def getProfileInfo(self, row_guid):
        ret = {}
        cur = self.conn.cursor()
        
        try:
            sql = "SELECT * FROM users WHERE users.row_guid = '{}'".format(str(row_guid));
            cur.execute(sql)
            profile_info = cur.fetchall()
            print("profile_info: {}".format(profile_info))

            if (len(profile_info) > 0):
                ret['username'] = profile_info[0][1]
                ret['email'] = profile_info[0][3]       

            sql = "SELECT COUNT(*) FROM plants AS p INNER JOIN plants_users pu ON p.id = pu.fk_plants INNER JOIN users u ON u.id = pu.fk_users WHERE u.row_guid = '{}'".format(str(row_guid))
            cur.execute(sql)
            count_plants = cur.fetchall()

            if (len(count_plants) > 0):
                ret['plants_count'] = count_plants[0][0]

            ret['success'] = True
            return ret


        except mariadb.Error as e: 
            print("Napaka pri dodajanju nove rastline")
            print("{}".format(str(e)))
            ret['error'] = 'Napaka pri pridobivanju rastlin'
            ret['success'] = False
            return ret


    def deleteUserPlant(self, id):
        ret = {}
        cur = self.conn.cursor()

        print("id: {}".format(id))
        
        try:
            sql = "DELETE FROM plants_users WHERE plants_users.id = {}".format(int(id));
            cur.execute(sql)

            self.conn.commit()

            ret['success'] = True
            return ret


        except mariadb.Error as e: 
            print("Napaka pri dodajanju nove rastline")
            print("{}".format(str(e)))
            ret['error'] = 'Napaka pri pridobivanju rastlin'
            ret['success'] = False
            return ret


    def change_password(self, old_password, new_password, row_guid):
        ret = {}
        cur = self.conn.cursor()

        #print("id: {}".format(id))
        
        try:
            sql = "UPDATE users SET users.password = cast(sha2(CONCAT(hash, '{}'), 256) as char) WHERE users.row_guid = '{}' AND users.password = cast(sha2(CONCAT(hash, '{}'), 256) as char)".format(new_password, row_guid, old_password);

            cur.execute(sql)

            if (cur.rowcount > 0):
                self.conn.commit()
                ret['success'] = True
                return ret
            else:
                self.conn.commit()
                ret['success'] = False
                ret['reason'] = "Staro geslo ni pravilno"
                return ret


        except mariadb.Error as e: 
            print("Napaka pri dodajanju nove rastline")
            print("{}".format(str(e)))
            ret['error'] = 'Napaka pri spremembi gesla'
            ret['success'] = False
            return ret


    def close_connection(self):
        self.conn.close()
