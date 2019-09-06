import mysql.connector as mcon
from mysql.connector import Error

def connect_to_db(phost: str, puser: str, ppass: str, pport: str, pdb: str) -> mcon.MySQLConnection:
    success: bool = False
    message: str = ''
    db: mcon.MySQLConnection = None
    try:
        db = mcon.connect(
            host = phost,
            user = puser,
            password = ppass,
            port = pport,
            database = pdb
        )
        success = True
    except Error as err:
        message = 'Erreur de connection : ' + str(err.msg)
    return success, message, db

def list_choix_interets(pdb: mcon.MySQLConnection):
    cursor = pdb.cursor()
    cursor.execute('SELECT * FROM interet WHERE libelle <> "N/A" ORDER BY id;')
    data = cursor.fetchall()
    return data

def cherche_match(pdb: mcon.MySQLConnection):
    cursor = None
    sexe = ''
    cherche = ''
    interets = []
    interets_lib = []
    while (sexe != 'M') and (sexe != 'F'):
        sexe = input('Quel est votre sexe (M/F) ? ')
    while (cherche != 'M') and (cherche != 'F') and (cherche != 'X'):
        cherche = input('De quel sexe est le partenaire cherché (M/F/X) ? ')
    print('Voici, avec leur code, les centres d\'intérêts possibles :')
    list_db_interets = list_choix_interets(pdb)
    list_db_interets_num = []
    for num, lib in list_db_interets:
        print('* ', num, '\t', lib)
        list_db_interets_num.append(str(num))
    cur_int = ''
    print('Saisissez un à un les codes de vos centres d\'intérêt puis E lorsque vous avez terminé : ')
    while (cur_int != 'E'):
        cur_int = input('--> ')
        if cur_int in list_db_interets_num:
            interets.append(int(cur_int))
            for num, lib in list_db_interets:
                if num == int(cur_int):
                    interets_lib.append(lib)
        elif cur_int != 'E':
            cur_int = ''
    if cherche == 'X':
        cond_sexe = ' (user.sexe="{}" OR user.sexe="{}") '.format('M', 'F')
    else:
        cond_sexe = ' user.sexe="{}" '.format(cherche)
    cond_cherche = ' (user.cherche="{}" OR user.cherche="X") '.format(sexe)
    cond_interets = ' score > 0 '
    myquery = 'SELECT v.nom, v.pseudo, v.date_naiss, v.sexe, v.cherche, v.ville, v.interet, '
    myquery += ' MATCH(user.interet) AGAINST("{}") AS score FROM user '.format(','.join(interets_lib))
    myquery += ' INNER JOIN v_user AS v ON user.id = v.id '
    myquery += ' WHERE {} AND {} HAVING {} ORDER BY score;'.format(cond_sexe, cond_cherche, cond_interets)
    cursor = pdb.cursor()
    cursor.execute(myquery)
    data = cursor.fetchall()
    disp_str = "{}, pseudo {}, de {}, né(e) le {}, {} cherchant un(e) {}, aimant {}, matchant avec un score de {}"
    for (nom, pseudo, ddn, sexe, ch, ville, interets, score) in data:
        print(disp_str.format(nom, pseudo, ville, ddn, sexe, str.replace(ch, 'X', 'H/F'), interets, score))

if __name__ == "__main__": 
    success: bool = False
    message: str = ''
    mydb: mcon.MySQLConnection = None
    success, message, mydb = connect_to_db('localhost', 'root', 'root', '3306', 'rencontre')
    if success:
        cherche_match(mydb)
    else:
        print(message)