import os
import sys
import csv

from tree import Tree
from node import Node

PROGRAM_NAME = sys.argv[0]
COMMAND = sys.argv[1]
INDEX_FILE_NAME = sys.argv[2]
DATA_ROOT = os.path.join(os.path.dirname(__file__), "..", "Data") # Data 폴더 경로 (상대 경로)

if COMMAND == "-c":
    assert len(sys.argv) == 4, "Command Line Error"
    b = int(sys.argv[3])
    
    # 새로 만들고 이미 존재한다면 덮어씀
    with open(INDEX_FILE_NAME, 'w', encoding="utf-8") as idx_file:
        idx_file.write(f'{b}\n') # File의 가장 첫 줄에 B를 적음

elif COMMAND == "-i":
    assert len(sys.argv) == 4, "Command Line Error"
    data_file_name = sys.argv[3]
    # 읽기 + 수정
    with open(INDEX_FILE_NAME, 'r+b') as idx_file:
        with open(os.path.join(DATA_ROOT, data_file_name), "r", encoding="utf-8-sig", newline="") as data_file:
            bpTree = Tree(idx_file)
            csv_reader = csv.reader(data_file)
            bpTree.insertion(csv_reader)

elif COMMAND == "-d":
    assert len(sys.argv) == 4, "Command Line Error"
    data_file_name = sys.argv[3]
    with open(INDEX_FILE_NAME, 'r+b') as idx_file:
        with open(os.path.join(DATA_ROOT, data_file_name), "r", encoding="utf-8-sig", newline="") as data_file:
            bpTree = Tree(idx_file)
            csv_reader = csv.reader(data_file)
            bpTree.deletion(csv_reader)

elif COMMAND == "-s":
    assert len(sys.argv) == 4, "Command Line Error"
    key = int(sys.argv[3])
    with open(INDEX_FILE_NAME, 'r+b') as idx_file:
        bpTree = Tree(idx_file)
        bpTree.single_search(key)

elif COMMAND == "-r":
    assert len(sys.argv) == 5, "Command Line Error"
    start_key = int(sys.argv[3])
    end_key = int(sys.argv[4])
    with open(INDEX_FILE_NAME, 'r+b') as idx_file:
        bpTree = Tree(idx_file)
        bpTree.ranged_search(start_key, end_key)
