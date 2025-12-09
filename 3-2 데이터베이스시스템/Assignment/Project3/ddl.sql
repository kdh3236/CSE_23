SET FOREIGN_KEY_CHECKS = 0;

-- --------------------------------------------
-- 1. CREATE TABLE
-- --------------------------------------------
CREATE TABLE branch (
    Branch_id     INT NOT NULL AUTO_INCREMENT,
    Name          VARCHAR(20) NOT NULL,
    Phone_number  VARCHAR(20) UNIQUE,
    Address       VARCHAR(100) UNIQUE,
    Manager_id    INT,
    PRIMARY KEY (Branch_id),
    UNIQUE KEY uq_branch_name   (Name),
    UNIQUE KEY uq_branch_phone  (Phone_number),
    UNIQUE KEY uq_branch_address(Address),
    KEY idx_for_branch_manager (Manager_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE employee (
    Employee_id   INT NOT NULL AUTO_INCREMENT,
    Fname         VARCHAR(15) NOT NULL,
    Lname         VARCHAR(15) NOT NULL,
    Phone_number  VARCHAR(20) UNIQUE,
    Branch_id     INT NOT NULL,
    PRIMARY KEY (Employee_id),
    UNIQUE KEY uq_employee_phone (Phone_number),
    KEY idx_for_employee_branch (Branch_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE customer (
    User_id        INT NOT NULL AUTO_INCREMENT,
    Fname          VARCHAR(15) NOT NULL,
    Lname          VARCHAR(15) NOT NULL,
    Phone_number   VARCHAR(20) UNIQUE,
    Supervision_id INT,
    Rrn            CHAR(10) UNIQUE,
    PRIMARY KEY (User_id),
    UNIQUE KEY uq_customer_phone (Phone_number),
    UNIQUE KEY uq_customer_rrn   (Rrn),
    KEY idx_for_customer_supervision (Supervision_id),
    KEY idx_for_customer_user_supervision (User_id, Supervision_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE account (
    Account_number INT NOT NULL AUTO_INCREMENT,
    State          ENUM('OPEN','STOP') DEFAULT 'OPEN',
    Balance        INT NOT NULL DEFAULT 0,
    User_id        INT NOT NULL,
    Manager_id     INT NOT NULL,
    PRIMARY KEY (Account_number),
    KEY idx_for_account_user        (User_id),
    KEY idx_for_account_manager     (Manager_id),
    KEY idx_for_account_user_manager(User_id, Manager_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE transaction (
    Transaction_id  INT NOT NULL AUTO_INCREMENT,
    From_account_id INT,
    To_account_id   INT,
    Type            ENUM('DEPOSIT','WITHDRAW','TRANSFER') NOT NULL,
    Amount          INT NOT NULL,
    Date            DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    State           ENUM('COMPLETED','REJECTED') NOT NULL DEFAULT 'COMPLETED',
    PRIMARY KEY (Transaction_id),
    KEY idx__for_from_account (From_account_id),
    KEY idx_for_to_account   (To_account_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE request (
    Request_id    INT NOT NULL AUTO_INCREMENT,
    Request_type  ENUM('CREATE','STOP','DELETE') NOT NULL,
    User_id       INT NOT NULL,
    Account_id    INT,
    Manager_id    INT NOT NULL,
    Status        ENUM('PENDING','APPROVED','REJECTED') NOT NULL DEFAULT 'PENDING',
    PRIMARY KEY (Request_id),
    KEY idx_for_request_user         (User_id),
    KEY idx_for_request_account      (Account_id),
    KEY idx_for_request_manager      (Manager_id),
    KEY idx_for_request_user_manager (User_id, Manager_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------
-- 2. FK Constraints
-- --------------------------------------------
ALTER TABLE employee
    ADD CONSTRAINT fk_employee_branch
        FOREIGN KEY (Branch_id)
        REFERENCES branch(Branch_id);

ALTER TABLE branch
    ADD CONSTRAINT fk_branch_manager
        FOREIGN KEY (Manager_id)
        REFERENCES employee(Employee_id);

ALTER TABLE customer
    ADD CONSTRAINT fk_customer_supervision
        FOREIGN KEY (Supervision_id)
        REFERENCES employee(Employee_id);

ALTER TABLE account
    ADD CONSTRAINT fk_account_user
        FOREIGN KEY (User_id)
        REFERENCES customer(User_id),
    ADD CONSTRAINT fk_account_manager
        FOREIGN KEY (Manager_id)
        REFERENCES employee(Employee_id),
    ADD CONSTRAINT fk_account_user_manager -- User와 Manager가 반드시 동일하게 매칭되도록 강제
        FOREIGN KEY (User_id, Manager_id)
        REFERENCES customer(User_id, Supervision_id);

ALTER TABLE transaction
    ADD CONSTRAINT fk_transaction_from_account
        FOREIGN KEY (From_account_id)
        REFERENCES account(Account_number),
    ADD CONSTRAINT fk_transaction_to_account
        FOREIGN KEY (To_account_id)
        REFERENCES account(Account_number);

ALTER TABLE request
    ADD CONSTRAINT fk_request_user
        FOREIGN KEY (User_id)
        REFERENCES customer(User_id),
    ADD CONSTRAINT fk_request_account
        FOREIGN KEY (Account_id)
        REFERENCES account(Account_number),
    ADD CONSTRAINT fk_request_manager
        FOREIGN KEY (Manager_id)
        REFERENCES employee(Employee_id),
    ADD CONSTRAINT fk_request_user_manager -- User와 Manager가 반드시 동일하게 매칭되도록 강제
        FOREIGN KEY (User_id, Manager_id)
        REFERENCES customer(User_id, Supervision_id);

SET FOREIGN_KEY_CHECKS = 1;