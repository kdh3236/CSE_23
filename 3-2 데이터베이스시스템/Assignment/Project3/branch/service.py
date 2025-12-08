from db import get_connection
from pymysql.cursors import DictCursor

def show_branch_detail(branch_id: int):
    """
    지점명, 주소, 전화번호, 지점장명, 해당 지점의 모든 사원명
    """
    connection = get_connection()
    cursor = connection.cursor(DictCursor)

    branch_sql = """
    SELECT *
    FROM branch
    WHERE Branch_id = %s
    """

    cursor.execute(branch_sql, (branch_id, ))
    branch = cursor.fetchone()

    if branch is None:
        print("[에러] 해당 지점이 존재하지 않습니다.", end='\n\n')
        cursor.close()
        connection.close()
        return

    manager_sql = """
    SELECT Fname, Lname
    From employee
    WHERE Employee_id = %s
    """

    cursor.execute(manager_sql, (branch["Manager_id"], ))
    manager = cursor.fetchone()

    manager_name = f"{manager['Fname']} {manager['Lname']}"

    employee_sql = """
    SELECT Fname, Lname, Phone_number
    From employee
    WHERE Branch_id = %s
    """

    cursor.execute(employee_sql, (branch_id,))
    employees = cursor.fetchall()

    print(f"지점명:\t {branch['Name']}")
    print(f"주소:\t {branch['Address']}")
    print(f"전화번호: {branch['Phone_number']}")
    print(f"지점장:\t {manager_name}")
    print("사원 목록")
    if employees:
        for e in employees:
            print(f" - 이름: {e['Fname']} {e['Lname']}, 전화번호: {e['Phone_number']}")
    else:
        print(" - 사원 없음")
    print()

    cursor.close()
    connection.close()