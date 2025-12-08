import pymysql as pms

def get_connection():
    connection = pms.connect(
        host="localhost",
        port=3306,        
        user="root",   
        password="*kwondh1018",
        db="bankapp",
        charset='utf8'
    )
    return connection


