import oracledb

oracledb.defaults.fetch_lobs = False


def create_connection():
    # oracle cloud
    # connection = oracledb.connect(
    #     user="kosa17",
    #     password="kosa2023oraclE",
    #     dsn="edudb_high",
    #     config_dir="C:\DEV\Python\Wallet_edudb",
    #     wallet_location="C:\DEV\Python\Wallet_edudb",
    #     wallet_password="pythonoracle21",
    # )
    connection = oracledb.connect("ace01/me@localhost:1521/xepdb1")
    return connection


CURSOR = oracledb.CURSOR
STRING = oracledb.STRING

if __name__ == "__main__":
    connection = create_connection()
    cursor = connection.cursor()
    cursor.execute("SELECT * FROM USERS")
    result = cursor.fetchall()

    for row in result:
        print(row)

    cursor.close()
    connection.close()
