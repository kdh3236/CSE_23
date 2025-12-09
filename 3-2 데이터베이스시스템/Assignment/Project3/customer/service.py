from db import get_connection

def check_customer_id(customer_id: int) -> bool:
    connection = get_connection()
    cursor = connection.cursor()

    sql = """
    SELECT User_id
    FROM customer
    WHERE User_id = %s 
    """

    cursor.execute(sql, (customer_id, ))
    result = cursor.fetchone()

    cursor.close()
    connection.close()

    return result is not None

def get_all_accounts(customer_id: int) -> tuple:
    connection = get_connection()
    cursor = connection.cursor()

    sql = """
    SELECT Account_number, State, Balance
    FROM account
    WHERE User_id = %s
    """

    cursor.execute(sql, (customer_id, ))
    result = cursor.fetchall()

    cursor.close()
    connection.close()

    return result

def get_account_details(customer_id: int, account_num: int) -> tuple:
    connection = get_connection()
    cursor = connection.cursor()

    sql = """
    SELECT t.From_account_id, t.To_account_id, t.Type, t.Amount, t.Date, t.State
    FROM transaction t 
    JOIN account a
    ON (
        (t.Type = 'TRANSFER' AND (t.From_account_id = a.Account_number OR t.To_account_id = a.Account_number))
        OR (t.Type = 'DEPOSIT'  AND t.To_account_id   = a.Account_number)
        OR (t.Type = 'WITHDRAW' AND t.From_account_id = a.Account_number)
    )
    JOIN customer c ON a.User_id = c.User_id
    WHERE c.User_id = %s AND a.Account_number = %s 
    ORDER BY t.Date DESC
    LIMIT 20
    """

    cursor.execute(sql, (customer_id, account_num))
    results = cursor.fetchall()

    cursor.close()
    connection.close()

    return results

def check_customer(customer_id: int, account_num: int) -> bool:
    """
    account_num에 해당하는 ACCOUNT의 User_id와
    Customer_id가 일치하는지 확인하는 함수
    """

    connection = get_connection()
    cursor = connection.cursor()

    sql = """
    SELECT User_id
    FROM account
    WHERE Account_number = %s
    """

    cursor.execute(sql, (account_num, ))
    if cursor.rowcount == 0:
        print("[에러] 존재하지 않은 계좌입니다.")
        return False

    user_id = cursor.fetchone()

    cursor.close()
    connection.close()

    return user_id[0] == customer_id

def deposit(customer_id: int, to_acc: int, amount: int) -> bool:
    if not check_customer(customer_id, to_acc):
        print("존재하지 않거나 권한 없는 계좌입니다.")
        return False
    
    connection = get_connection()
    cursor = connection.cursor()

    acc_sql = """
    UPDATE account
    SET Balance = Balance + %s
    WHERE Account_number = %s AND State = 'OPEN'
    """

    cursor.execute(acc_sql, (amount, to_acc))

    if cursor.rowcount == 0:
        print("[에러] 요구하신 계좌를 찾을 수 없거나 정지 상태입니다.")

        cursor.close()
        connection.close()

        return False

    tr_sql = """
    INSERT INTO transaction (To_account_id, Type, Amount, State)
    VALUES (%s, 'DEPOSIT', %s, 'COMPLETED');
    """

    cursor.execute(tr_sql, (to_acc, amount))
    if cursor.rowcount == 0:
        print("[에러] 거래 내역 저장에 실패하였습니다.")
        connection.rollback()
        cursor.close()
        connection.close()
        return False
    
    connection.commit()

    cursor.close()
    connection.close()

    return True


def withdraw(customer_id: int, from_acc: int, amount: int) -> bool:
    if not check_customer(customer_id, from_acc):
        print("존재하지 않거나 권한 없는 계좌입니다.")
        return False
    
    connection = get_connection()
    cursor = connection.cursor()

    acc_sql = """
    UPDATE account
    SET Balance = Balance - %s
    WHERE Account_number = %s AND Balance >= %s AND State = 'OPEN';
    """

    cursor.execute(acc_sql, (amount, from_acc, amount))
    if cursor.rowcount == 0:
        print("[에러] 요구하신 계좌를 찾을 수 없거나 잔액이 부족합니다.")

        tr_sql = """
        INSERT INTO transaction (From_account_id, Type, Amount, State)
        VALUES (%s, 'TRANSFER', %s, 'REJECTED')
        """

        cursor.execute(tr_sql, (from_acc, amount))
        if cursor.rowcount == 0:
            print("[에러] 거래 내역 저장에 실패하였습니다.")
            connection.rollback()
            cursor.close()
            connection.close()
            return False
    
        connection.commit()

        cursor.close()
        connection.close()

        return False
    
    tr_sql = """
    INSERT INTO transaction (From_account_id, Type, Amount, State)
    VALUES (%s, 'WITHDRAW', %s, 'COMPLETED');
    """

    cursor.execute(tr_sql, (from_acc, amount))
    if cursor.rowcount == 0:
        print("[에러] 거래 내역 저장에 실패하였습니다.")
        connection.rollback()
        cursor.close()
        connection.close()
        return False
    
    connection.commit()

    cursor.close()
    connection.close()

    return True

def transfer(customer_id: int, from_acc: int, to_acc: int, amount: int) -> bool:
    if not check_customer(customer_id, from_acc):
        print("존재하지 않거나 권한 없는 계좌입니다.")
        return False
    
    connection = get_connection()
    cursor = connection.cursor()

    acc_sql = """
    UPDATE account AS f JOIN account AS t 
        ON f.Account_number = %s AND t.Account_number = %s
    SET f.Balance = f.Balance - %s, t.Balance = t.Balance + %s
    WHERE f.Balance >= %s AND f.State = 'OPEN' AND t.State = 'OPEN'
    """

    cursor.execute(acc_sql, (from_acc, to_acc, amount, amount, amount))
    if cursor.rowcount == 0:
        print("[에러] 요구하신 계좌를 찾을 수 없거나 잔액이 부족합니다.")
        # 수정
        cursor.close()
        connection.close()

        return False
    
    tr_sql = """
    INSERT INTO transaction (From_account_id, To_account_id, Type, Amount, State)
    VALUES (%s, %s, 'TRANSFER', %s, 'COMPLETED')
    """

    cursor.execute(tr_sql, (from_acc, to_acc, amount))
    if cursor.rowcount == 0:
        print("[에러] 거래 내역 저장에 실패하였습니다.")
        connection.rollback()
        cursor.close()
        connection.close()
        return False
    
    connection.commit()

    cursor.close()
    connection.close()

    return True

def get_manager_id(customer_id: int) -> int:
    connection = get_connection()
    cursor = connection.cursor()

    sql = """
    SELECT Supervision_id
    FROM customer
    WHERE User_id = %s
    """

    cursor.execute(sql, (customer_id, ))
    manager_id = cursor.fetchone()

    cursor.close()
    connection.close()

    return manager_id[0]

def create_request(customer_id: int) -> bool:
    connection = get_connection()
    cursor = connection.cursor()

    manager_id = get_manager_id(customer_id)

    sql = """
    INSERT INTO request (Request_type, User_id, Manager_id)  
    VALUES (%s, %s, %s)
    """

    cursor.execute(sql, ('CREATE', customer_id, manager_id))
    connection.commit()

    result = cursor.rowcount == 1

    cursor.close()
    connection.close()

    return result 

def delete_request(customer_id: int, account_num: int) -> bool:
    connection = get_connection()
    cursor = connection.cursor()

    manager_id = get_manager_id(customer_id)

    sql = """
    INSERT INTO request (Request_type, User_id, Account_id, Manager_id)  
    VALUES (%s, %s, %s, %s)
    """

    cursor.execute(sql, ('DELETE', customer_id, account_num, manager_id))
    connection.commit()

    result = cursor.rowcount == 1

    cursor.close()
    connection.close()

    return result

def stop_request(customer_id: int, account_num: int) -> bool:
    connection = get_connection()
    cursor = connection.cursor()

    manager_id = get_manager_id(customer_id)

    sql = """
    INSERT INTO request (Request_type, User_id, Account_id, Manager_id)  
    VALUES (%s, %s, %s, %s)
    """

    cursor.execute(sql, ('STOP', customer_id, account_num, manager_id))
    connection.commit()

    result = cursor.rowcount == 1

    cursor.close()
    connection.close()

    return result