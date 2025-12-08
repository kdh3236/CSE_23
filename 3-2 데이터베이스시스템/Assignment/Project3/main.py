from branch.service import show_branch_detail
from admin.service import check_admin_id, add_customer_info, delete_customer_info, create_account,\
                        delete_account, stop_account, unfreeze_account, change_request_state, get_request
from customer.service import check_customer_id, get_all_accounts, get_account_details, \
                        deposit, withdraw, transfer, create_request, delete_request, stop_request

####################################################
# 1. 각 모드에 맞춘 Menu 프린팅
####################################################

def print_main_menu():
    print("\n---------------Bank Management System---------------")
    print("1. 관리자 메뉴")
    print("2. 사용자 메뉴")
    print("3. 지점 정보")
    print("4. 나가기")
    print("----------------------------------------------------", end='\n\n')
    
def print_admin_menu():
    print("\n---------------Administrator Menu---------------")
    print("1. 새로운 고객 추가")
    print("2. 고객 정보 삭제")
    print("3. 계좌 개설")
    print("4. 계좌 해지")
    print("5. 계좌 정지")
    print("6. 계좌 정지 해제")
    print("7. 사용자 요청 처리")
    print("8. 메인 메뉴로 돌아가기")
    print("------------------------------------------------", end='\n\n')

def print_customer_menu():
    print("\n---------------Customer Menu---------------")
    print("1. 거래 내역 확인")  # 특정 계좌의 잔액 + 거래 내역
    print("2. 입금")
    print("3. 출금")
    print("4. 이체")
    print("5. 계좌 개설 요청")
    print("6. 계좌 해지 요청")
    print("7. 계좌 정지 요청")
    print("8. 메인 메뉴로 돌아가기")
    print("------------------------------------------------", end='\n\n')

def print_branch_info():
    print("[안내] 아래 지점 중, 정보를 보기 원하는 지점을 선택하세요.", end='\n\n')
    print(" 지점 번호  |    지점명")
    print("    1      |    서울")
    print("    2      |    대구")
    print("    3      |    수원", end='\n\n')

####################################################
# 2. DB와 연동하여 실제로 처리하는 Warping function
####################################################

# Admin ID가 실제 존재하는지 확인
def check_admin_id_(admin_id):
    return check_admin_id(admin_id)

# User ID가 실제로 존재하는지 확인
def check_customer_id_(customer_id):
    return check_customer_id(customer_id)

def print_branch_info_(branch_id):
    print(f"[안내] 지점 번호 {branch_id} 지점의 정보입니다.", end='\n\n')
    show_branch_detail(branch_id)


# 해당 관리자_id를 Manager_id로 갖는 새로운 customer 생성
# customer_id를 어떻게 지정할 지가 고민
def create_customer_info_(admin_id):
    print("[안내] 고객 정보를 추가합니다.", end='\n\n')
    name = input("고객의 이름을 '성 이름' 형태로 입력하세요: ")
    fname, lname = name.split()
    supervision_id = admin_id
    phone_num = input("고객의 핸드폰 번호를 공백 없이 입력하세요: ")
    rrn = input("고객의 주민 번호를 공백 없이 입력하세요: ")

    info = (fname, lname, phone_num, supervision_id, rrn)
    result = add_customer_info(info)

    if result: print("[완료] 고객 정보가 추가되었습니다.", end='\n\n')
    else: print("[에러] 고객 정보가 추가되지 않았습니다. 다시 시도해주세요.", end='\n\n')

def delete_customer_info_(admin_id):
    print("[안내] 고객 정보를 삭제합니다.", end='\n\n')
    customer_id = int(input("삭제하길 원하는 고객의 ID를 입력하세요: "))

    result = delete_customer_info(admin_id, customer_id)

    if result: print("[완료] 고객 정보가 삭제되었습니다.", end='\n\n')
    else: print("[에러] 고객 정보가 삭제되지 않았습니다. 다시 시도해주세요.", end='\n\n')

def create_account_(admin_id, user_id) -> bool:
    result = create_account(admin_id, user_id)

    if result: 
        print("[완료] 계좌가 개설되었습니다.", end='\n\n')
        return True
    else: 
        print("[에러] 계좌가 개설되지 않았습니다. 다시 시도해주세요.", end='\n\n')
        return False

def delete_account_(account_num, admin_id, user_id) -> bool:
    result = delete_account(account_num, admin_id, user_id)

    if result: 
        print("[완료] 계좌가 삭제되었습니다.", end='\n\n')
        return True
    else: 
        print("[에러] 계좌가 해지되지 않았습니다. 다시 시도해주세요.", end='\n\n')
        return False

def stop_account_(account_num, admin_id, user_id):
    result = stop_account(account_num, admin_id, user_id)

    if result: 
        print("[완료] 계좌가 정지되었습니다.", end='\n\n')
        return True
    else: 
        print("[에러] 계좌가 정지되지 않았습니다. 다시 시도해주세요.", end='\n\n')
        return False
    
def unfreeze_account_(account_num, admin_id, user_id):
    result = unfreeze_account(account_num, admin_id, user_id)

    if result: 
        print("[완료] 계좌의 정지가 해제 되었습니다.", end='\n\n')
        return True
    else: 
        print("[에러] 계좌의 정지가 해제되지 않았습니다. 다시 시도해주세요.", end='\n\n')
        return False
    
def process_user_request_(admin_id):
    print("[안내] 고객의 요청을 처리합니다.", end='\n\n')
    
    # REQUEST Entity에서 요청된게 있는지 확인하고 반환
    # 가장 오래된 Request부터 하나씩 처리 가능하도록 구현
    request = get_request(admin_id)

    if request is None:
        print("[완료] 요청이 없습니다.")
        return 0
    
    request_id, user_id, request_type, account_num = request

    if request_type == "CREATE": 
        result = create_account_(admin_id, user_id)

        if result: 
            change_request_state(request_id, 'APPROVED')
            print("[완료] 사용자 요청 처리가 완료되었습니다.", end='\n\n')
        else: 
            change_request_state(request_id ,'REJECTED')
            print("[에러] 계좌 개설 조건을 만족하지 못해 요청이 거절되었습니다.", end='\n\n')

    elif request_type == "DELETE": 
        result = delete_account_(account_num, admin_id, user_id)

        if result: 
            change_request_state(request_id, 'APPROVED')
            print("[완료] 사용자 요청 처리가 완료되었습니다.", end='\n\n')
        else: 
            change_request_state(request_id, 'REJECTED')
            print("[에러] 계좌 해지 조건을 만족하지 못해 요청이 거절되었습니다.", end='\n\n')

    elif request_type == "STOP": 
        result = stop_account_(account_num, admin_id, user_id)

        if result: 
            change_request_state(request_id, 'APPROVED')
            print("[완료] 사용자 요청 처리가 완료되었습니다.", end='\n\n')
        else: 
            change_request_state(request_id, 'REJECTED')
            print("[에러] 계좌 정지 조건을 만족하지 못해 요청이 거절되었습니다.", end='\n\n')
    
    else:
        print("[에러] 잘못된 요청입니다.", end='\n\n')

# Customer 처리 함수 
def view_all_account_(customer_id):
    results = get_all_accounts(customer_id)

    if results:
        for account_num, state, balance in results:
            print(f"계좌 번호: {account_num} | 상태: {state} | 잔액: {balance}")
    else:
        print("사용자의 계좌가 없습니다.", end='\n\n')
    
def view_account_detail_(customer_id):    
    print("[안내] 계좌 내역을 조회합니다.", end='\n\n')
    account_num = int(input("조회하실 계좌번호를 입력하세요: "))

    results = get_account_details(customer_id, account_num)
    
    if results:
        print("[완료] 거래 내역 조회가 완료되었습니다.", end='\n\n')
        for from_num, to_num, type, amount, date, state in results:
            from_num = from_num if from_num is not None else "없음"
            to_num = to_num if to_num   is not None else "없음"

            print(f"거래 유형: {type} | 출금 계좌: {from_num} | 입금 계좌 {to_num} | 금액: {amount}원 | 날짜: {date} | 상태: {state}")
    else:
        print("거래 내역이 없거나 찾을 수 없습니다.", end='\n\n')
    

def deposit_(customer_id):
    print("[안내] 입금합니다.", end='\n\n')

    to_acc = int(input("입금하실 계좌번호를 입력하세요: "))
    amount = int(input("입금액을 입력하세요: "))

    if amount <= 0:
        print("[에러] 0원 이하의 거래는 발생할 수 없습니다.", end='\n\n')
        return 0
    elif amount >= 1000000:
        print("[에러] 백만원 이상의 거래는 발생할 수 없습니다.", end='\n\n')
        return 0
    
    result = deposit(customer_id, to_acc, amount)

    if result: 
        print(f"[완료] 계좌 {to_acc}에 {amount:,}원 입금이 완료되었습니다.", end='\n\n')
    else: 
        print("[에러] 입금 요청이 거절 되었습니다. 다시 시도해주세요.", end='\n\n')

def withdraw_(customer_id):
    print("[안내] 출금합니다.", end='\n\n')
    
    from_acc = int(input("\n출금하실 계좌번호를 입력하세요: "))
    amount = int(input("출금액을 입력하세요: "))

    result = withdraw(customer_id, from_acc, amount)

    if amount <= 0:
        print("[에러] 0원 이하의 거래는 발생할 수 없습니다.", end='\n\n')
        return 0
    elif amount >= 1000000:
        print("[에러] 백만원 이상의 거래는 발생할 수 없습니다.", end='\n\n')
        return 0

    if result:
        print(f"[완료] 계좌 {from_acc}에서 {amount:,}원 출금이 완료되었습니다.", end='\n\n')
    else:
        print("[에러] 출금 요청이 거절 되었습니다. 다시 시도해주세요.", end='\n\n')


def transfer_(customer_id):
    print("[안내] 이체합니다.", end='\n\n')
    
    from_acc = int(input("\n출금 계좌번호를 입력하세요: "))
    to_acc = int(input("입금 계좌번호를 입력하세요: "))
    amount = int(input("송금할 금액을 입력하세요: "))

    if amount <= 0:
        print("[에러] 0원 이하의 거래는 발생할 수 없습니다.", end='\n\n')
        return 0
    elif amount >= 1000000:
        print("[에러] 백만원 이상의 거래는 발생할 수 없습니다.", end='\n\n')
        return 0

    result = transfer(customer_id, from_acc, to_acc, amount)

    if result:
        print(f"[완료] 계좌 번호 {from_acc}에서 {to_acc}로 {amount:,}원 송금이 완료되었습니다.", end='\n\n')
    else:
        print("[에러] 이체 요청이 거절 되었습니다. 다시 시도해주세요.", end='\n\n')


def request_create_account_(customer_id):
    print("[안내] 신규 계좌 개설을 요청합니다.", end='\n\n')

    result = create_request(customer_id)
    
    if result: 
        print("[완료] 요청이 완료 되었습니다. 담당자가 확인 후 처리해드리겠습니다.", end='\n\n')
    else:
        print("[에러] 요청이 처리되지 않았습니다. 다시 시도해주세요.", end='\n\n')


def request_delete_account_(customer_id):
    print("[안내] 계좌 해지를 요청합니다.", end='\n\n')
    
    account_num = int(input("\n폐쇄 요청할 계좌번호를 입력하세요: "))

    result = delete_request(customer_id, account_num)
    
    if result:
        print("[완료] 요청이 완료 되었습니다. 담당자가 확인 후 처리해드리겠습니다.", end='\n\n')
    else:
        print("[에러] 요청이 처리되지 않았습니다. 다시 시도해주세요.", end='\n\n')
   

def request_stop_account_(customer_id):
    print("[안내] 계좌 정지를 요청합니다.", end='\n\n')

    account_num = int(input("\n정지 요청할 계좌번호를 입력하세요: "))

    result = stop_request(customer_id, account_num)

    if result:
        print("[완료] 요청이 완료 되었습니다. 담당자가 확인 후 처리해드리겠습니다.", end='\n\n')
    else:
        print("[에러] 요청이 처리되지 않았습니다. 다시 시도해주세요.", end='\n\n')
    

####################################################
# 3. 사용자의 Choice를 적절한 Warping function으로 매핑
####################################################

def process_admin_choice(choice, admin_id):
    if choice == 1:
        create_customer_info_(admin_id)
    elif choice == 2:
        delete_customer_info_(admin_id)
    elif choice == 3:
        print("[안내] 계좌를 개설합니다.", end='\n\n')
        user_id = int(input("계좌 개설을 원하는 고객 ID를 입력하세요: "))
        create_account_(admin_id, user_id)
    elif choice == 4:
        print("[안내] 계좌를 해지합니다.", end='\n\n')
        user_id = int(input("계좌 해지를 원하는 고객 ID를 입력하세요: "))
        account_num = int(input("계좌 해지를 원하는 계좌 번호를 입력하세요: "))
        delete_account_(account_num, admin_id, user_id)
    elif choice == 5:
        print("[안내] 계좌를 정지합니다", end='\n\n')
        user_id = int(input("계좌 정지를 원하는 고객 ID를 입력하세요: "))
        account_num = int(input("계좌 정지를 원하는 계좌 번호를 입력하세요: "))
        stop_account_(account_num, admin_id, user_id)
    elif choice == 6:
        print("[안내] 계좌를 해제합니다", end='\n\n')
        user_id = int(input("계좌 정지 해제를 원하는 고객 ID를 입력하세요: "))
        account_num = int(input("계좌 정지 해제를 원하는 계좌 번호를 입력하세요: "))
        unfreeze_account_(account_num, admin_id, user_id)
    elif choice == 7:
        process_user_request_(admin_id)
        

def process_customer_choice(choice, customer_id):
    print("-" * 10, "사용자 계좌 목록", "-" * 10)
    view_all_account_(customer_id) 
    print("-" * 38)

    if choice == 1:
        view_account_detail_(customer_id)
    elif choice == 2:
        deposit_(customer_id)
    elif choice == 3:
        withdraw_(customer_id)
    elif choice == 4:
        transfer_(customer_id)
    elif choice == 5:
        request_create_account_(customer_id)
    elif choice == 6:
        request_delete_account_(customer_id)
    elif choice == 7:
        request_stop_account_(customer_id)
        

####################################################
# 4. 관리자 모드와 사용자 모드 실행
####################################################

def admin_mode(admin_id):
    while (1):
        print_admin_menu()
        
        choice = int(input("[안내] 원하는 메뉴를 선택해주세요. (1 ~ 8): "))

        if 1 <= choice <= 7:
            process_admin_choice(choice, admin_id)
        elif choice == 8:
            print("[안내] 메인 메뉴로 돌아갑니다.", end='\n\n')
            break
        else:
            print("[에러] 잘못된 선택입니다. 메인 메뉴로 돌아갑니다.", end ='\n\n')
            break

def customer_mode(customer_id):
    while (1):
        print_customer_menu()

        choice = int(input("[안내] 원하는 메뉴를 선택해주세요. (1 ~ 8): "))

        if 1 <= choice <= 7:
            process_customer_choice(choice, customer_id)
        elif choice == 8:
            print("[안내] 메인 메뉴로 돌아갑니다.", end='\n\n')
            break
        else:
            print("[에러] 잘못된 선택입니다. 메인 메뉴로 돌아갑니다.", end ='\n\n')
            break

def branch_mode():
    while (1):
        print_branch_info()

        branch_id = int(input("[안내] 확인을 원하는 지점 번호를 선택해주세요. 0을 입력하시면 메인 메뉴로 돌아갑니다. (1 ~ 3, 0: EXIT): "))

        if branch_id == 0: 
            break
        elif 1 <= branch_id <= 3:
            print_branch_info_(branch_id)
        else:
            print("[에러] 잘못된 선택입니다. 메인 메뉴로 돌아갑니다.")
            break
           
####################################################
#  5. Main application 실행     
####################################################

def main():
    while (1):
        print_main_menu()

        mode = int(input("[안내] 원하는 메뉴를 선택해주세요 (1 ~ 4): "))

        if mode == 1:
            admin_id = int(input("[안내] 관리자 ID를 입력해주세요: "))

            if not check_admin_id_(admin_id):
                print("[에러] 잘못된 관리자 ID입니다.", end='\n\n')
                continue
            
            admin_mode(admin_id)  # 관리자 모드로 진입

        elif mode == 2:
            customer_id = int(input("[안내] 사용자 ID를 입력해주세요: "))

            if not check_customer_id_(customer_id):
                print("[에러] 잘못된 사용자 ID입니다.", end='\n\n')
                continue
            
            customer_mode(customer_id)  # 고객 모드로 진입

        elif mode == 3:
            branch_mode()

        elif mode == 4:
            print("[안내] 프로그램 종료")
            break

        else:
            print("[에러] 잘못된 모드입니다. 다시 선택해주세요.", end='\n\n')

    return 0

if __name__ == "__main__":
    main()