import random
from db import get_connection

connection = get_connection()
cursor = connection.cursor()

def add_branch():
    branches = [
        (1, "Seoul", "11111111", "Wangsimni"),
        (2, "Daegu", "22222222", "Suseonggu"),
        (3, "Suwon", "33333333", "Paldalgu")
    ]

    sql = """
    INSERT INTO branch (Branch_id, Name, Phone_number, Address) 
    VALUES (%s, %s, %s, %s)
    """

    cursor.executemany(sql, branches)
    connection.commit()

# FK 참조 제약 때문에 Manager_id만 Employee 추가 후 삽입
def add_manager_id():
    manager_ids = [
        # (Manager_id, Branch_id)
        (1, 1),  
        (4, 2),
        (7, 3)
    ]

    sql = """
    UPDATE branch
    SET Manager_id = %s
    WHERE Branch_id = %s
    """

    cursor.executemany(sql, manager_ids)
    connection.commit()

def add_employee():
    employees = [
        (1, "kim", "minji", "00000000", 1),
        (2, "lee", "jihoon", "00000001", 1),
        (3, "park", "yejun", "00000002", 1),
        (4, "choi", "seoyeon", "00000003", 2),
        (5, "jung", "doyun", "00000004", 2),
        (6, "kang", "ha-eun", "00000005" , 2),
        (7, "cho", "siwoo", "00000006", 3),
        (8, "han", "soomin", "00000007", 3),
        (9, "lim", "junho", "00000008", 3)
    ]

    sql = "INSERT INTO employee VALUES (%s, %s, %s, %s, %s)"
    cursor.executemany(sql, employees)
    connection.commit()

# Random한 숫자 생성
def generate_unique_numbers(count, length):
    
    numbers = set()
    while len(numbers) < count:
        num = ''.join(random.choice("0123456789") for _ in range(length))
        numbers.add(num)
    return list(numbers)

def add_customer():
    connection = get_connection()
    cursor = connection.cursor()

    customers = [
        ("bae", "woojin", 1),
        ("yoo", "seulgi", 1),
        ("song", "jaehyun", 1),
        ("ahn", "sunmi", 2),
        ("yoon", "hayoone", 2),
        ("jang", "junsu", 2),
        ("go", "eunbi", 3),
        ("kwon", "taeyoung", 3),
        ("oh", "jihyo", 3),
        ("shin", "dongwoo", 4),
        ("ryu", "chaewon", 4),
        ("moon", "jisung", 4),
        ("hwang", "yubin", 5),
        ("nam", "hyejin", 5),
        ("lee", "hyunwoo", 5),
        ("kim", "areum", 6),
        ("park", "jisu", 6),
        ("choi", "wooyeon", 6),
        ("jung", "minsoo", 7),
        ("kang", "dahye", 7),
        ("cho", "inpyo", 7),
        ("han", "sol", 8),
        ("lim", "dohyun", 8),
        ("jeon", "kyungmin", 8),
        ("hong", "seokjin", 9),
        ("baek", "nayeon", 9),
        ("seo", "yechul", 9)
    ]

    count = len(customers)

    # Random하게 Rrn, Phone_number 생성
    phone_numbers = generate_unique_numbers(count, 8)
    rrns = generate_unique_numbers(count, 10)

    # Data 구성
    insert_data = []
    for i, (fname, lname, sup_id) in enumerate(customers):
        insert_data.append(
            (fname, lname, phone_numbers[i], sup_id, rrns[i])
        )

    sql = """
    INSERT INTO customer (Fname, Lname, Phone_number, Supervision_id, Rrn)
    VALUES (%s, %s, %s, %s, %s)
    """

    cursor.executemany(sql, insert_data)
    connection.commit()

    cursor.close()
    connection.close()

if __name__ == "__main__":
    add_branch()
    add_employee()
    add_manager_id()
    add_customer()
    cursor.close()
    connection.close()