from db import get_connection

def check_admin_id(admin_id: int) -> bool:
    connection = get_connection()
    cursor = connection.cursor()

    sql = """
    SELECT Employee_id
    FROM employee
    WHERE Employee_id = %s
    """

    cursor.execute(sql, (admin_id, ))
    result = cursor.fetchone()

    cursor.close()
    connection.close()

    return result is not None
    

def add_customer_info(info: tuple) -> bool:
    # info = (fname, lname, phone_number, supervision_id, rrn)
    connection = get_connection()
    cursor = connection.cursor()

    fname, lname, phone_num, supervision_id, rrn = info

    sql = """
    INSERT INTO customer (Fname, Lname, Phone_number, Supervision_id, Rrn)
    VALUES (%s, %s, %s, %s, %s)
    """
    
    try:
        cursor.execute(sql, (fname, lname, phone_num, supervision_id, rrn))
        connection.commit()

        return True
    
    except  Exception as e:
        print("한 관리자는 최대 10명의 고객만 관리할 수 있습니다.", end='\n\n')
        return False

    finally:
        cursor.close()
        connection.close()


def delete_customer_info(admin_id:int , customer_id: int) -> bool:
    connection = get_connection()
    cursor = connection.cursor()

    try:
        # 1. 고객과 관련된 요청이 존재하는지 확인
        request_sql = """
        SELECT COUNT(*)
        FROM request
        WHERE Manager_id = %s AND User_id = %s AND Status = 'PENDING'; 
        """
        cursor.execute(request_sql, (admin_id, customer_id))
        count = cursor.fetchone()[0]

        if count > 0:
            print("대기 중인 요청이 존재하는 경우 고객 정보를 삭제할 수 없습니다.")
            return False

        # 2. 고객이 갖고 있는 계좌가 존재하는지 확인
        acc_sql = """
        SELECT COUNT(*)
        FROM account
        WHERE Manager_id = %s AND User_id = %s; 
        """
        cursor.execute(acc_sql, (admin_id, customer_id))
        count = cursor.fetchone()[0]

        if count > 0:
            print("사용자의 계좌가 존재하는 경우, 고객 정보를 삭제할 수 없습니다.")
            return False
        
        # 3. 고객 정보 삭제
        delete_sql = """
        DELETE FROM customer
        WHERE Supervision_id = %s AND User_id = %s;
        """

        cursor.execute(delete_sql, (admin_id, customer_id))

        if cursor.rowcount == 0:
            print("[에러] 고객 정보 삭제 중 문제가 발생하였습니다.")
            connection.rollback()
            return False

        connection.commit()
        return True
    
    except Exception as e:
        print("[에러]: ", e)

        try:
            connection.rollback()
        except:
            pass
        
        return False
    
    finally:
        cursor.close()
        connection.close()


def create_account(admin_id: int, customer_id: int):
    # 계좌 상태 -> Open
    connection = get_connection()
    cursor = connection.cursor()

    sql = """
    INSERT INTO account (User_id, Manager_id)
    VALUES (%s, %s)
    """

    try:
        cursor.execute(sql, (customer_id, admin_id))
        connection.commit()

        return True
    
    except  Exception as e:
        print("한 사용자는 최대 10개의 계좌만 보유할 수 있습니다.", end='\n\n')
        return False

    finally:
        cursor.close()
        connection.close()

def delete_account(account_num: int, admin_id:int , customer_id: int) -> bool:
    connection = get_connection()
    cursor = connection.cursor()

    try:    
        # 1. 잔액이 0원인지 확인
        balance_sql = """
        SELECT Balance
        FROM account
        WHERE Account_number = %s AND Manager_id = %s AND User_id = %s;
        """

        cursor.execute(balance_sql, (account_num, admin_id, customer_id))
        result = cursor.fetchone()

        if result is None:
            print("일치하는 계좌를 찾을 수 없습니다.")
            return False
        
        balance = result[0]
        if balance != 0:
            print("잔액이 0원이 아닌 계좌는 삭제할 수 없습니다.")
            return False
        
        # 2. 현재 계좌와 관련있는 PENDING 상태의 Request가 있는지 확인
        request_sql = """
        SELECT COUNT(*)
        FROM request
        WHERE Account_id = %s AND Manager_id = %s AND User_id = %s AND Status = 'PENDING';
        """

        cursor.execute(request_sql, (account_num, admin_id, customer_id))
        count = cursor.fetchone()[0]

        if count >= 1:
            print("대기 중인 요청이 존재하는 경우 계좌를 삭제할 수 없습니다.")
            return False
        
        # 3. 현재 계좌와 관련있는 Request 모두 삭제
        delete_request_sql = """
        DELETE FROM request
        WHERE Account_id = %s AND Manager_id = %s AND User_id = %s;
        """

        cursor.execute(delete_request_sql, (account_num, admin_id, customer_id))
        
        # 4. 현재 계좌와 관련있는 입금 / 출금 transaction 모두 삭제
        delete_tr_sql = """
        DELETE From transaction
        WHERE TYPE IN ('DEPOSIT', 'WITHDRAW') AND (From_account_id = %s or To_account_id = %s);
        """

        cursor.execute(delete_tr_sql, (account_num, account_num))

        # 5. 현재 계좌와 관련있는 이체 내역에서 해당 Account_id를 NULL로 변경
        delete_tr_sql = """
        UPDATE transaction
        SET From_account_id = NULL
        WHERE TYPE = 'TRANSFER' AND From_account_id = %s;
        """
        cursor.execute(delete_tr_sql, (account_num, ))
        
        delete_tr_sql = """
        UPDATE transaction
        SET To_account_id = NULL
        WHERE TYPE = 'TRANSFER' AND To_account_id = %s;
        """
        cursor.execute(delete_tr_sql, (account_num, ))

        # 6. 계좌 자체를 삭제
        delete_acc_sql = """
        DELETE FROM account
        WHERE Account_number = %s AND Manager_id = %s AND User_id = %s;
        """
        cursor.execute(delete_acc_sql, (account_num, admin_id, customer_id))

        if cursor.rowcount == 0:
            print("[에러] 계좌 삭제 중 문제가 발생하였습니다.")
            connection.rollback()
            return False

        connection.commit()
        return True
    
    except Exception as e:
        print("[에러]: ", e)

        try:
            connection.rollback()
        except:
            pass
        
        return False
    
    finally:
        cursor.close()
        connection.close()


def stop_account(account_num: int, admin_id:int , customer_id: int) -> bool:
    """
    계좌 소유주가 Customer_id와 일치하는지 확인
    계좌 관리자가 Admin_id와 일치하는지 확인
    계좌의 상태가 'OPEN'인지 확인
    """
    connection = get_connection()
    cursor = connection.cursor()

    sql = """
    UPDATE account
    SET State = 'STOP'
    WHERE Account_number = %s AND User_id = %s AND State = 'OPEN' AND Manager_id = %s 
    """

    cursor.execute(sql, (account_num, customer_id, admin_id))
    connection.commit()
    
    result = cursor.rowcount == 1

    cursor.close()
    connection.close()

    return result 

def unfreeze_account(account_num: int, admin_id:int , customer_id: int) -> bool:
    """
    계좌 소유주가 Customer_id와 일치하는지 확인
    계좌 관리자가 Admin_id와 일치하는지 확인
    계좌의 상태가 'STOP'인지 확인
    """

    connection = get_connection()
    cursor = connection.cursor()

    sql = """
    UPDATE account
    SET State = 'OPEN'
    WHERE Account_number = %s AND User_id = %s AND State = 'STOP' AND Manager_id = %s 
    """

    cursor.execute(sql, (account_num, customer_id, admin_id))
    connection.commit()
    
    result = cursor.rowcount == 1

    cursor.close()
    connection.close()

    return result 

def change_request_state(request_id: int, state: str) -> None:
    connection = get_connection()
    cursor = connection.cursor()

    sql = """
    UPDATE request
    SET Status = %s
    WHERE Request_id = %s
    """

    cursor.execute(sql, (state, request_id))
    connection.commit()

    cursor.close()
    connection.close()


def get_request(admin_id: int) -> tuple:
    """
    특정 관리자 ID와 일치하는 요청만 보여줌
    요청한 Request_id / User의 ID / 요청 종류 / 계좌 번호를 반환
    가장 오래된 Request 하나만 반환하도록 구현
    """
    connection = get_connection()
    cursor = connection.cursor()

    sql = """
    SELECT Request_id, User_id, Request_type, Account_id
    FROM request
    WHERE Manager_id = %s AND Status = 'PENDING'
    ORDER BY Request_id ASC
    LIMIT 1
    """

    cursor.execute(sql, (admin_id, ))
    result = cursor.fetchone() 

    cursor.close()
    connection.close()

    return result 