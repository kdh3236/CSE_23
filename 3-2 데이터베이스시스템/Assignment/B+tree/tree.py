import sys
from node import Node

def parse_line(line):
    parsed_line = [l.strip() for l in line.split('|')]

    node_id = int(parsed_line[0])
    is_leaf = int(parsed_line[1])
    keys = list(map(int, parsed_line[2].split(','))) if parsed_line[2] else []
    childs = list(map(int, parsed_line[3].split(','))) if parsed_line[3] else []
    next_leaf_id = int(parsed_line[4]) if parsed_line[4] and parsed_line[4] != 'None' else None

    return node_id, is_leaf, keys, childs, next_leaf_id

class Tree():
    def __init__(self, idx_file):
        self.idx_file = idx_file
        # 바이너리 모드에서 텍스트로 읽기
        first_line = idx_file.readline()
        if isinstance(first_line, bytes):
            first_line = first_line.decode('utf-8')
        self.b = int(first_line.rstrip('\n'))
        self.nodes = []
        self.load_node()

    def load_node(self):
        # self.node initialize
        self.nodes.clear()

        for line in self.idx_file:
            # 바이너리 모드에서 텍스트로 읽기
            if isinstance(line, bytes):
                line = line.decode('utf-8')
            line = line.rstrip('\n')
            if not line:  # 빈 줄 건너뛰기
                continue

            node_id, is_leaf, keys, childs, next_leaf_id = parse_line(line)
            node = Node(self.b, node_id, is_leaf, keys, childs, next_leaf_id)
            self.nodes.append(node)
    
    def get_root(self):
        if len(self.nodes) == 0:
            return None
        root = self.nodes[0] 
        assert root.id == 0, "첫 번째 Node는 Root node이어야 합니다."
        
        return root
    
    def save_file(self):
        self.idx_file.seek(0)
        self.idx_file.truncate()

        # 첫 줄에 b 값 저장
        self.idx_file.write(f'{self.b}\n'.encode('utf-8'))
        
        # node_id 순으로 정렬 후 저장
        sorted_nodes = sorted(self.nodes, key=lambda x: x.id)
        for node in sorted_nodes:
            self.idx_file.write((node.to_string() + '\n').encode('utf-8'))
        
        self.idx_file.flush()
        
    def set_id(self):
        for i, node in enumerate(self.nodes):
            node.id = i
    
    def find_parent(self, node):
        parent = None
        index = None

        for n in self.nodes:
            if n.is_leaf:
                continue

            childs = [v for _, v in n.p] + [n.r]

            if node.id in childs:
                index = childs.index(node.id)
                parent = n
                return parent, index
        
        return parent, index
    
    def leaf_node_check(self):
        # Leaf Node의 r, next_leaf_id 수정
        for i, n in enumerate(self.nodes):
            if n.is_leaf:
                if i < len(self.nodes) - 1:
                    n.r = i+1
                    n.next_leaf_id = i+1
                else:
                    n.r = None
                    n.next_leaf_id = None
    
    
    def insertion(self, csv_reader):
        for row in csv_reader:
            assert len(row) >= 2, "Data file에는 key, vaule 쌍이 존재해야 합니다."
            key = int(row[0])
            value = int(row[1])
            raw_key = key # for debug

            print(f"입력할 Key, Value 쌍은 다음과 같습니다. {key}, {value}")
            
            # Tree에 아무 Node도 존재하지 않는 경우
            if len(self.nodes) == 0:
                node = Node(self.b, 0, 1, [key], [value], None)
                print(f"{key}: root 생성")
                self.nodes.append(node)
                continue
            
            # 위치를 찾아야함
            root = self.get_root()
            if root is None:
                # 빈 트리인 경우
                node = Node(self.b, 0, 1, [key], [value], None)
                self.nodes.append(node)
                continue
            
            node = self.search(root, key, False) # 일치하는 위치의 Leaf Node를 찾는다.

            if node is None or not node.is_leaf:
                print("일치하는 Node를 찾을 수 없거나 Leaf node가 아닙니다.")
                continue

            # node에 이미 같은 Key가 있는지 확인
            if node.searchLeaf(key) is not None:
                print("중복되는 Key는 Insert할 수 없습니다.")
                continue
            
            index = 0

            if node.is_full(): # 찾은 Leaf Node에 하나 추가하면 용량 초과
                # Split이 필요한 경우
                while (1):
                    # Leaf node에 insert할 때, Search를 통해 중복 Key 검사를 하므로 여기서 또 할 필요는 없을 듯
                    
                    # node가 None이면 추가할 게 없다는 뜻이므로 즉시 종료
                    if node is None:
                        break

                    # Node에 우선 삽입
                    if node.is_leaf:
                        node.p_.append((key, value))
                        node.p_.sort(key=lambda k: k[0])
                    else:
                        keys = [k for k, _ in node.p]
                        childs = [v for _, v in node.p] + [node.r]

                        if index == len(node.p):
                            keys.append(key)
                            childs.append(value) # 원래 왼쪽 Child가 위치한 위치 옆에 추가
                        else:
                            keys.insert(index, key)
                            childs.insert(index+1, value) # 원래 왼쪽 Child가 위치한 위치 옆에 추가
                        
                        node.p = list(zip(keys, childs[:-1]))
                        node.r = childs[-1]


                    if not node.is_full(): # 이 경우 node에 추가해줘야 함 (key, value) / 추가하고 Loop를 종료하도록 한다.
                        # Parent node에 공간이 남아있다면 추가한 후 업데이트 해줘야함
                        # Parent node도 가득 찼다면 insert에서 update
                        if node.is_leaf:
                            node.m = len(node.p_)
                        else:
                            node.m = len(node.p)
                        
                        break

                    # split은 우선 node.p 또는 p_에 key, value 쌍을 추가하는 작업부터 수행한다.
                    left_key, left_value , right_key, right_value, m = self.split(node)


                    # parent node도 꽉 찼다면 다시 Split 후 Insert 반복
                    node, key, value, index = self.insert(node, left_key, left_value , right_key, right_value, m) # insert의 결과로 Parent node를 받음

                    id = node.id if node else None

                    self.set_id()

                    self.leaf_node_check()                

            else: # Leaf node에 그냥 추가해도 되는 경우
                node.p_.append((key, value))
                node.p_.sort(key=lambda k: k[0])
                node.m = len(node.p_)  # m 값 업데이트
            
            print(f"Insert {raw_key} 이후 최종 상태")
            print("-" * 50) 
            for n in self.nodes:
                if n.is_leaf:
                    print(n.id, int(n.is_leaf), n.p_, n.m, n.r, n.next_leaf_id)
                else:
                    print(n.id, int(n.is_leaf), n.p, n.m, n.r, n.next_leaf_id)
            print("-" * 50, end="\n\n") 
        
        # 변경사항을 파일에 저장
        self.save_file()

    def insert(self, node, left_key, left_value , right_key, right_value, m): # node: 현재 insert를 하고자하는 Node
        parent = None
        key = None 
        value = None
        index = None

        # 1. Root Node이면서 Leaf Node인 경우
        if node.id == 0 and node.is_leaf:
            print("Case 1")
            left_id = 1
            right_id = 2
            
            root = Node(self.b, 0, 0, [m], [left_id, right_id], None)
            right_child = Node(self.b, right_id, 1, right_key, right_value, None)
            
            # 기존 node를 업데이트
            node.id = left_id
            node.p_ = list(zip(left_key, left_value)) if left_key else []
            node.next_leaf_id = right_id
            node.r = right_id
            node.m = len(node.p_)
            
            # nodes 배열 업데이트
            self.nodes.insert(0, root)
            self.nodes.append(right_child)

            parent = None # 추가 삽입 없이 종료되도록 한다.

            return parent, key, value, index
        # 2. Root Node이고 Leaf Node가 아닌 경우
        elif node.id == 0 and not node.is_leaf:
            print("Case 2")
            left_id = 1
            right_id = 2
            
            root = Node(self.b, 0, 0, [m], [left_id, right_id], None)      
            right_child = Node(self.b, right_id, 0, right_key, right_value, None)
            
            # 기존 node를 left child로 변경
            node.id = left_id
            node.p = list(zip(left_key, left_value[:-1])) if left_key else []
            node.r = left_value[-1]
            node.m = len(node.p)
            
            # nodes 배열 업데이트
            self.nodes.insert(0, root)

            for idx, n in enumerate(self.nodes):
                if idx == 0 or n.is_leaf:
                    continue
                for i, (k, v) in enumerate(n.p):
                    if v is not None and v >= 0:
                        n.p[i] = (k, v + 1)
                # r
                if n.r is not None and n.r >= 0:
                    n.r += 1

            if not right_child.is_leaf:
                for i, (k, v) in enumerate(right_child.p):
                    if v is not None:
                        right_child.p[i] = (k, v + 1)
                if right_child.r is not None:
                    right_child.r += 1

            if len(self.nodes) == right_id: # self.nodes의 가장 끝에 추가해야되는 경우
                self.nodes.append(right_child)
            else:
                self.nodes.insert(right_id, right_child)

            # node.id 업데이트 전에 전체 node를 돌면서 각 child pointer가 right_id 이상인 부분은 + 2씩
            # 왜냐하면 2개가 생겼기 떄문
            # split이후의 left child까지 관리해야 하는지 
            for idx, n in enumerate(self.nodes):
                if idx == 0 or n.is_leaf:
                    continue
                for i, (k, v) in enumerate(n.p):
                    if v is not None and v >= right_id:
                        n.p[i] = (k, v + 1)
                if n.r is not None and n.r >= right_id:
                    n.r += 1

            # insertion에서 id 정렬 및 leaf node의 r, next_leaf_id 정렬한다.

            parent = None # 추가 삽입 없이 종료되도록 한다.
            
            return parent, key, value, index
        # 3. Root Node가 아니고 Leaf Node인 경우
        elif node.id != 0 and node.is_leaf:
            print("Case 3")
            right_id = node.id + 1  # 새로운 ID 할당
            
            right_child = Node(self.b, right_id, 1, right_key, right_value, node.next_leaf_id)
            
            # 기존 node 업데이트
            node.p_ = list(zip(left_key, left_value)) if left_key else []
            node.next_leaf_id = right_id
            node.r = right_id
            node.m = len(node.p_)

        
            # parent 찾는 logic 추가
            parent = None
            index = None

            parent, index = self.find_parent(node)
            
            assert parent is not None, "parent를 찾을 수 없습니다."

            key = m
            value = right_id

            # node.id 위치에 추가해야 맞는 위치에 추가된다.
            if len(self.nodes) == right_id: # self.nodes의 가장 끝에 추가해야되는 경우
                self.nodes.append(right_child)
            else:
                self.nodes.insert(right_id, right_child)

            # node.id 업데이트 전에 전체 node를 돌면서 각 child pointer가 right_id 이상인 부분은 + 1씩
            # 왜냐하면 1개가 생겼기 떄문
            for n in self.nodes:
                if n.is_leaf:
                    continue
                for i, (k, v) in enumerate(n.p):
                    if v is not None and v >= right_id:
                        n.p[i] = (k, v + 1)
                if n.r is not None and n.r >= right_id:
                    n.r += 1
            
            return parent, key, value, index
        # 4. Root도 아니고 Leaf도 아닌 경우
        elif node.id != 0 and not node.is_leaf:
            print("Case 4")
            right_id = node.id+1
            right_child = Node(self.b, right_id, 0, right_key, right_value, None)
            
            node.p = list(zip(left_key, left_value[:-1])) if left_key else []
            node.r = left_value[-1]
            node.m = len(node.p)

            # parent 찾는 logic 추가
            parent = None
            index = None
            
            parent, index = self.find_parent(node)

            assert parent is not None, "parent를 찾을 수 없습니다."

            key = m
            value = right_id

            # node.id 위치에 추가해야 맞는 위치에 추가된다.
            if len(self.nodes) == right_id: # self.nodes의 가장 끝에 추가해야되는 경우
                self.nodes.append(right_child)
            else:
                self.nodes.insert(right_id, right_child)

            for n in self.nodes:
                if n.is_leaf:
                    continue
                for i, (k, v) in enumerate(n.p):
                    if v is not None and v >= right_id:
                        n.p[i] = (k, v + 1)
                if n.r is not None and n.r >= right_id:
                    n.r += 1

            return parent, key, value, index
        # 위 네 가지 경우 중 하나도 속하지 않는 경우
        else:
            print("잘못된 Insertion의 경우입니다.")
            return parent, key, value, index
        
    def split(self, node): # Node.p는 삽입할 (Key, Value)가 Append된 이후 정렬까지 된 상태이어야 한다.
        middle_idx = (node.m-1) // 2 
        
        if node.is_leaf:
            left = node.p_[:middle_idx+1]
            right = node.p_[middle_idx+1:]
            
            left_key = [k for k, _ in left]
            left_value = [v for _, v in left]
            right_key = [k for k, _ in right]
            right_value = [v for _, v in right]

            m = right_key[0]
            
            return left_key, left_value , right_key, right_value, m
        else:
            middle_idx = middle_idx + 1 # //이 Floor 연산이라 1 추가해야됨
            m, v = node.p[middle_idx] 
            # Non-leaf node split: middle key는 부모로 올리고 right에서 제거
            left = node.p[:middle_idx]
            right = node.p[middle_idx+1:]  # middle key는 부모로 올리므로 제외

            left_key = [k for k, _ in left] 
            left_value = [v for _, v in left] # Child는 제거 없이 전부 사용
            left_value.append(v)
            right_key = [k for k, _ in right]
            right_value = [v for _, v in right] + [node.r]
            
            return left_key, left_value , right_key, right_value, m

    def deletion(self, csv_reader):
        for row in csv_reader:
            if len(row) >= 1:  # key가 있는지 확인
                key = int(row[0])
                print(f"삭제할 Key: {key}")

                if len(self.nodes) == 0:
                    print("Tree 안에 Node가 없어 delete할 수 없습니다.")
                    continue

                # 위치를 찾아야함
                root = self.get_root()
                if root is None:
                    print("Root가 없습니다.")
                    continue

                if len(self.nodes) == 1:
                    print("Root만 존재하는 경우")

                    for i, (k, v) in enumerate(root.p_):
                        if k == key:
                            leaf_index = i
                        
                    del root.p_[i]
                    root.m = root.m - 1

                    # Root node의 경우 is_half가 만족되지 않아도 괜찮다.    

                    # Root가 비면 모든 node 삭제
                    if root.m == 0:
                        self.nodes = []
                    continue

                leaf_node = self.search(root, key, False) # 일치하는 위치의 Leaf Node를 찾는다.

                if leaf_node is None or not leaf_node.is_leaf:
                    print("일치하는 Node를 찾을 수 없습니다.")
                    continue
                    
                # 리프 노드에서 키 찾기
                leaf_index = None
                for i, (k, v) in enumerate(leaf_node.p_):
                    if k == key:
                        leaf_index = i
                        break
                    
                if leaf_index is None:
                    print("[DEBUG]:", leaf_node.p_)
                    leaf_node = self.search(root, key, True)
                    print("찾은 leaf node에서 key 값을 찾을 수 없습니다.")
                    continue


                min_key = False
                if leaf_index == 0 and self.nodes[leaf_node.id-1].is_leaf: # 삭제할 키가 해당 노드의 첫 번째 키인 경우 + 가장 왼쪽 Leaf가 아닌 경우
                    min_key = True # 최소키인지 여부를 체크

                target = None
                target_index = None

                if min_key:
                    target, target_index = self.find_target(key)

                if min_key and target is None:
                    print("Min Key이지만 상위 노드에 Key값이 없습니다.")

                # 우선 Leaf node에서 삭제
                del leaf_node.p_[leaf_index]
                leaf_node.m = leaf_node.m - 1
                
                # Case 1: Min_key도 아니고, leaf 삭제 문제 없음
                if not min_key and leaf_node.is_half_for_leaf():
                    print("Case 1")

                # Case 2: Min_key이고, leaf 삭제 문제 없음
                if min_key and leaf_node.is_half_for_leaf():
                    print("Case 2")

                    if len(leaf_node.p_) > 0:
                        new_min_key, _ = leaf_node.p_[0]
                        _, v = target.p[target_index]
                        target.p[target_index] = (new_min_key, v)


                # Case 3: Min_key가 아니고, leaf 삭제 문제 있음
                if not min_key and not leaf_node.is_half_for_leaf():
                    print("Case 3")
                    # 빌려오기 또는 병합
                    parent, parent_index = self.find_parent(leaf_node)
                    if parent is None:
                        print("Case 3: Parent를 찾을 수 없습니다.")
                        return

                    left = None
                    right = None
                    left, right = self.find_sibling(leaf_node, parent, parent_index)

                    if left and right: # left, right 모두 존재하는 경우
                        print("Case 3: left, right 모두 존재하는 경우")
                        # 1. Left에서 빌려올 수 있는 경우
                        if left.m > (self.b - 1) // 2:
                            print("Case 3: 왼쪽에서 빌려옴")
                            lk, lv = left.p_[-1]

                            # 현재 Node의 Internal key가 Left[-1]로 변함
                            if len(leaf_node.p_) > 0:
                                internal_key, _ = leaf_node.p_[0] # 원래 현재 Node의 구분자
                                new_target, new_target_index = self.find_target(internal_key)
                                if new_target is not None:
                                    _, v = new_target.p[new_target_index]
                                    new_target.p[new_target_index] = (lk, v)

                            del left.p_[-1]
                            left.m = left.m - 1

                            # Case 3에선 len(leaf_node.p_) == 0 / b=3인 경우가 나오면 안됨 

                            leaf_node.p_.insert(0, (lk, lv))
                            leaf_node.m = leaf_node.m + 1

                        
                        # 2. Right에서 빌려올 수 있는 경우
                        elif right.m > (self.b - 1) // 2:
                            print("Case 3: 오른쪽에서 빌려옴")
                            rk, rv = right.p_[0]

                            del right.p_[0]
                            right.m = right.m - 1

                            # Right의 min_key가 변경 -> Right의 target도 바뀌어야 함
                            # 기존 min_key인 rk로 찾고 새로운 key값으로 교체한다/
                            if len(right.p_) > 0:
                                new_min_key, _ = right.p_[0]
                                right_target, right_index = self.find_target(rk)
                                if right_target is not None: # 바뀌어야 하는 Target 대상이 있다면
                                    _, v = right_target.p[right_index]
                                    right_target.p[right_index] = (new_min_key, v)

                            leaf_node.p_.append((rk, rv))
                            leaf_node.m = leaf_node.m + 1
                        
                        # 3. Merge 필요
                        else:
                            print("Case 3: Merge 필요")
                            # Left와 Right 모두 merge 가능
                            if left and right:
                                print("Case 3: Left와 Right 모두 merge 가능")
                                # Left와 merge 
                                remove_index = parent_index - 1 # 구분자를 제거해야한다.
                                after_merge = self.merge_leaf_nodes(left, leaf_node, parent, remove_index)
                                # Parent가 underflow되는지 확인
                                if after_merge and not after_merge.is_half_for_internal():
                                    self.check_parent(after_merge)
                            elif left:
                                print("Case 3: Left만 존재하는 경우")
                                # Left와 merge
                                remove_index = parent_index - 1
                                after_merge = self.merge_leaf_nodes(left, leaf_node, parent, remove_index)
                                # Parent가 underflow되는지 확인
                                if after_merge and not after_merge.is_half_for_internal():
                                    self.check_parent(after_merge)
                            elif right:
                                print("Case 3: Right만 존재하는 경우")
                                # Right와 merge 
                                remove_index = parent_index
                                after_merge = self.merge_leaf_nodes(leaf_node, right, parent, remove_index)
                                # Parent가 underflow되는지 확인
                                if after_merge and not after_merge.is_half_for_internal():
                                    self.check_parent(after_merge)
                    elif left: # left만 존재하는 경우
                        print("Case 3: Left만 존재하는 경우")
                        # 1.Left에서 빌려올 수 있는 경우
                        if left.m > (self.b - 1) // 2:
                            print("Case 3: Left에서 빌려옴")
                            lk, lv = left.p_[-1]

                            # 현재 Node의 Internal key가 Left[-1]로 변함
                            if len(leaf_node.p_) > 0:
                                internal_key, _ = leaf_node.p_[0]
                                new_target, new_target_index = self.find_target(internal_key)
                                if new_target is not None:
                                    _, v = new_target.p[new_target_index]
                                    new_target.p[new_target_index] = (lk, v)

                            del left.p_[-1]
                            left.m = left.m - 1

                            # Case 3에선 이 경우가 나오면 안됨 len(leaf_node.p_) == 0 / b=3인 경우    
                            leaf_node.p_.insert(0, (lk, lv))
                            leaf_node.m = leaf_node.m + 1

                        # 2. Merge
                        else:
                            print("Case 3: Merge 필요")
                            # Left와 merge
                            print("Case 3: Left와 merge") 
                            remove_index = parent_index - 1
                            after_merged = self.merge_leaf_nodes(left, leaf_node, parent, remove_index)
                            # Parent가 underflow되는지 확인
                            if after_merged and not after_merged.is_half_for_internal():
                                self.check_parent(after_merged)
                    elif right: # right만 존재하는 경우
                        print("Case 3: Right만 존재하는 경우")
                        # 1. Right에서 빌려올 수 있는 경우
                        if right.m > (self.b - 1) // 2:
                            rk, rv = right.p_[0]

                            del right.p_[0]
                            right.m = right.m - 1

                            # Right의 min_key가 변경 -> Right의 target도 바뀌어야 함
                            # 기존 min_key인 rk로 찾고 새로운 key값으로 교체한다/
                            if len(right.p_) > 0:
                                new_min_key, _ = right.p_[0]
                                right_target, right_index = self.find_target(rk)
                                if right_target is not None: # 바뀌어야 하는 Target 대상이 있다면
                                    _, v = right_target.p[right_index]
                                    right_target.p[right_index] = (new_min_key, v)

                            leaf_node.p_.append((rk, rv))
                            leaf_node.m = leaf_node.m + 1
                        
                        # 2. Merge 필요
                        else:
                            print("Case 3: Merge 필요")
                            print("Case 3: Right와 merge")
                            # Right와 merge
                            remove_index = parent_index
                            after_merged = self.merge_leaf_nodes(leaf_node, right, parent, remove_index)
                            # Parent가 underflow되는지 확인
                            if after_merged and not after_merged.is_half_for_internal():
                                self.check_parent(after_merged)
                    
                # Case 4: Min_key이고, leaf 삭제 문제 있음
                if min_key and not leaf_node.is_half_for_leaf():
                    print("Case 4")
                    # 우선 Min key 처리 
                    if len(leaf_node.p_) > 0:
                        new_min_key = leaf_node.p_[0][0]
                        _, v = target.p[target_index]
                        target.p[target_index] = (new_min_key, v)

                    # 이후 빌려오기 또는 병합
                    parent, parent_index = self.find_parent(leaf_node)
                    if parent is None:
                        print("Case 4: Parent를 찾을 수 없습니다.")

                    left = None
                    right = None
                    left, right = self.find_sibling(leaf_node, parent, parent_index)

                    # 삭제 결과로 현재 node가 비면 left나 right의 구분자를 땡겨와야됨
                    if len(leaf_node.p_) == 0:
                        if left:
                            new_min_key = left.p_[0][0]
                            _, v = target.p[target_index]
                            target.p[target_index] = (new_min_key, v)
                        elif right:
                            new_min_key = right.p_[0][0]
                            _, v = target.p[target_index]
                            target.p[target_index] = (new_min_key, v)

                    if left and right: # left, right 모두 존재하는 경우
                        print("Case 4: left, right 모두 존재하는 경우")
                        # 1. Left에서 빌려올 수 있는 경우
                        if left.m > (self.b - 1) // 2:
                            print("Case 4: 왼쪽에서 빌려옴")
                            lk, lv = left.p_[-1]

                            # target이 새로운 구분자로 바뀌어야 한다.
                            # 현재 Node의 구분자가 변경
                            _, v = target.p[target_index]   
                            target.p[target_index] = (lk, v)

                            del left.p_[-1]
                            left.m = left.m - 1
                            
                            if len(leaf_node.p_) == 0: # b=3인 경우    
                                leaf_node.p_.append((lk, lv)) # 이 경우에는 leaf_node.p_가 비어있어 insert가 불가능
                                leaf_node.m = leaf_node.m + 1
                            else:
                                leaf_node.p_.insert(0, (lk, lv))
                                leaf_node.m = leaf_node.m + 1
                        
                        # 2. Right에서 빌려올 수 있는 경우
                        elif right.m > (self.b - 1) // 2:
                            print("Case 4: 오른쪽에서 빌려옴")
                            rk, rv = right.p_[0]

                            del right.p_[0]
                            right.m = right.m - 1

                            # Right의 구분자도 변경
                            if len(right.p_) > 0:
                                new_right_min_key, _ = right.p_[0] 
                                right_target, right_index = self.find_target(rk) # 기존 rk 값으로 target 찾음
                                if right_target is not None: # 바뀌어야 하는 Target 대상이 있다면
                                    _, v = right_target.p[right_index]
                                    right_target.p[right_index] = (new_right_min_key, v)

                            if len(leaf_node.p_) == 0: # b=3인 경우    
                                # 현재 node에 아무것도 없는 경우에는 new_min_key, _ = leaf_node.p_[0]로 하면 index 에러
                                # right node가 삽입될 것이고 그때 right node를 새로운 min_key로 사용해야 한다.
                                _, v = target.p[target_index]   
                                target.p[target_index] = (rk, v)

                                leaf_node.p_.append((rk, rv)) # 이 경우에는 leaf_node.p_가 비어있어 insert가 불가능
                                leaf_node.m = leaf_node.m + 1
                            else:
                                # target이 새로운 구분자로 바뀌어야 한다.
                                # 현재 Node의 구분자가 변경
                                if len(leaf_node.p_) > 0:
                                    new_min_key, _ = leaf_node.p_[0] # 기존 min_key node는 이미 삭제된 상태
                                    _, v = target.p[target_index]   
                                    target.p[target_index] = (new_min_key, v)

                                leaf_node.p_.append((rk, rv))
                                leaf_node.m = leaf_node.m + 1
                            
                        # 3. Merge 필요
                        else:
                            # Left와 Right 모두 merge 가능
                            print("Case 4: Merge 필요")
                            print("Case 4: Left와 Right 모두 merge 가능")
                            if left and right:
                                # Left와 merge (left가 더 작은 ID를 가지므로)
                                remove_index = parent_index - 1
                                after_merged = self.merge_leaf_nodes(left, leaf_node, parent, remove_index)
                                # Parent가 underflow되는지 확인
                                if after_merged and not after_merged.is_half_for_internal():
                                    self.check_parent(after_merged)
                            elif left:
                                # Left와 merge
                                remove_index = parent_index - 1
                                after_merged = self.merge_leaf_nodes(left, leaf_node, parent, remove_index)
                                # Parent가 underflow되는지 확인
                                if after_merged and not after_merged.is_half_for_internal():
                                    self.check_parent(after_merged)
                            elif right:
                                # Right와 merge (현재 노드를 left로, right를 right로)
                                remove_index = parent_index
                                after_merged = self.merge_leaf_nodes(leaf_node, right, parent, remove_index)
                                # Parent가 underflow되는지 확인
                                if after_merged and not after_merged.is_half_for_internal():
                                    self.check_parent(after_merged)
                    elif left: # left만 존재하는 경우
                        print("Case 4: Left만 존재하는 경우")
                        # 1.Left에서 빌려올 수 있는 경우
                        if left.m > (self.b - 1) // 2:
                            print("Case 4: Left에서 빌려옴")
                            lk, lv = left.p_[-1]

                            # target이 새로운 구분자로 바뀌어야 한다.
                            # 현재 Node의 구분자가 변경
                            _, v = target.p[target_index]   
                            target.p[target_index] = (lk, v)

                            del left.p_[-1]
                            left.m = left.m - 1
                            
                            if len(leaf_node.p_) == 0: # b=3인 경우    
                                leaf_node.p_.append((lk, lv)) # 이 경우에는 leaf_node.p_가 비어있어 insert가 불가능
                                leaf_node.m = leaf_node.m + 1
                            else:
                                leaf_node.p_.insert(0, (lk, lv))
                                leaf_node.m = leaf_node.m + 1
                        # 2. Merge
                        else:
                            print("Case 4: Merge 필요")
                            print("Case 4: Left와 merge")
                            # Left와 merge
                            remove_index = parent_index - 1
                            after_merged = self.merge_leaf_nodes(left, leaf_node, parent, remove_index)
                            # Parent가 underflow되는지 확인
                            if after_merged and not after_merged.is_half_for_internal():
                                self.check_parent(after_merged)
                    elif right: # right만 존재하는 경우
                        print("Case 4: Right만 존재하는 경우")
                        # 1. Right에서 빌려올 수 있는 경우
                        if right.m > (self.b - 1) // 2:
                            print("Case 4: Right에서 빌려옴")
                            rk, rv = right.p_[0]

                            del right.p_[0]
                            right.m = right.m - 1

                            # Right의 구분자도 변경
                            if len(right.p_) > 0:
                                new_right_min_key, _ = right.p_[0] 
                                right_target, right_index = self.find_target(rk) # 기존 rk 값으로 target 찾음
                                if right_target is not None: # 바뀌어야 하는 Target 대상이 있다면
                                    _, v = right_target.p[right_index]
                                    right_target.p[right_index] = (new_right_min_key, v)

                            if len(leaf_node.p_) == 0: # b=3인 경우    
                                # 현재 node에 아무것도 없는 경우에는 new_min_key, _ = leaf_node.p_[0]로 하면 index 에러
                                # right node가 삽입될 것이고 그때 right node를 새로운 min_key로 사용해야 한다.
                                _, v = target.p[target_index]   
                                target.p[target_index] = (rk, v)

                                leaf_node.p_.append((rk, rv)) # 이 경우에는 leaf_node.p_가 비어있어 insert가 불가능
                                leaf_node.m = leaf_node.m + 1
                            else:
                                # target이 새로운 구분자로 바뀌어야 한다.
                                # 현재 Node의 구분자가 변경
                                if len(leaf_node.p_) > 0:
                                    new_min_key, _ = leaf_node.p_[0] # 기존 min_key node는 이미 삭제된 상태
                                    _, v = target.p[target_index]   
                                    target.p[target_index] = (new_min_key, v)

                                leaf_node.p_.append((rk, rv))
                                leaf_node.m = leaf_node.m + 1
                        
                        # 2. Merge 필요
                        else:
                            print("Case 4: Merge 필요")
                            print("Case 4: Right와 merge")
                            # Right와 merge
                            remove_index = parent_index
                            after_merged = self.merge_leaf_nodes(leaf_node, right, parent, remove_index)
                            # Parent가 underflow되는지 확인
                            if after_merged and not after_merged.is_half_for_internal():
                                self.check_parent(after_merged)

                # 모든 변경사항 후 field 업데이트
                self.set_id()
                self.leaf_node_check()

                self.print_tree(key)
        
        # 변경사항을 파일에 저장
        self.save_file()

    def print_tree(self, key):
        print(f"Delete {key} 이후 최종 상태")
        print("-" * 50) 
        for n in self.nodes:
            if n.is_leaf:
                print(n.id, int(n.is_leaf), n.p_, n.m, n.r, n.next_leaf_id)
            else:
                print(n.id, int(n.is_leaf), n.p, n.m, n.r, n.next_leaf_id)
        print("-" * 50, end="\n\n")  

    
    def find_sibling(self, node, parent, parent_index):
        left = None
        right = None
        
        # childs 배열: [v for _, v in parent.p] + [parent.r]
        # parent_index는 이 childs 배열에서의 인덱스
        
        # Left sibling 찾기
        if parent_index > 0:
            # childs[parent_index-1]에 해당하는 child 찾기
            if parent_index - 1 < len(parent.p):
                left_id = parent.p[parent_index-1][1]  
            else:
                left_id = parent.r
            if left_id is not None and left_id < len(self.nodes):
                left = self.nodes[left_id]
            
        # Right sibling 찾기  
        if parent_index < len(parent.p) + (1 if parent.r is not None else 0) - 1:
            # childs[parent_index+1]에 해당하는 child 찾기
            if parent_index + 1 < len(parent.p):
                right_id = parent.p[parent_index+1][1]
            else:
                right_id = parent.r
            if right_id is not None and right_id < len(self.nodes):
                right = self.nodes[right_id]

        return left, right 
    
    def find_target(self, key):
        target = None
        target_index = None

        for n in self.nodes:
            if n.is_leaf:
                continue

            keys = [k for k, _ in n.p]
            if key in keys:
                target = n # 추가로 수정해야할 Node / 중간키가 들어있음
                target_index = keys.index(key)
                break

        return target, target_index
    
    # Leaf node 두 개를 Merge
    def merge_leaf_nodes(self, left, right, parent, remove_index):
        # right의 모든 키를 left에 추가한다.
        left.p_.extend(right.p_)
        left.p_.sort(key=lambda k: k[0]) 
        left.m = len(left.p_)
        
        # left의 next_leaf_id 업데이트
        left.next_leaf_id = right.next_leaf_id
        left.r = right.r

        # remove_index는 구분자 위치
        if remove_index < len(parent.p): # Parent에서 구분자를 제거
            del parent.p[remove_index]
        else: # 이 경우에는 parent.r을 left.r로 바꾸어야 제대로 동작한다. 
            if remove_index > 0 and remove_index - 1 < len(parent.p):
                del parent.p[remove_index - 1]
            # parent.r은 left.r로 업데이트
            parent.r = left.id
            
        parent.m = len(parent.p)

        # right에 대한 pointer를 left.id로 바꾼다.
        new_p = []
        for (k, v) in parent.p:
            if v == right.id:
                new_p.append((k, left.id))
            else:
                new_p.append((k, v))
        parent.p = new_p

        if parent.r == right.id:
            parent.r = left.id
        
        # right를 nodes 배열에서 제거하고 ID 재정렬
        removed_id = right.id
        self.nodes.remove(right)
        
        for n in self.nodes:
            # node id를 -1씩
            if n.id is not None and n.id > removed_id:
                n.id -= 1

            if n.is_leaf:
                # leaf인 경우에는 removed_id보다 크면 r, next_lead_id 조정
                if n.next_leaf_id is not None and n.next_leaf_id > removed_id:
                    n.next_leaf_id -= 1
                if n.r is not None and n.r > removed_id:
                    n.r -= 1
            else:
                # r만 조정
                n.p = [(k, (v - 1 if v is not None and v > removed_id else v)) for (k, v) in n.p]
                if n.r is not None and n.r > removed_id:
                    n.r -= 1
        
        return parent
    
    # Merge 이후, parent가 underflow라면 처리
    def check_parent(self, node):
        if node is None:
            return
        
        print("Parnet rebuilding")
        # Root node인 경우
        if node.id == 0:
            # Root가 비면 child를 위로 올려야 됨
            if node.m == 0 and node.r is not None:
                removed_id = node.id  # 0
                self.nodes.remove(node)

                for n in self.nodes:
                    if n.id is not None and n.id > removed_id:
                        n.id -= 1

                for n in self.nodes:
                    if n.is_leaf:
                        if n.next_leaf_id is not None and n.next_leaf_id > removed_id:
                            n.next_leaf_id -= 1
                        if n.r is not None and n.r > removed_id:
                            n.r -= 1
                    else:
                        for i, (k, v) in enumerate(n.p):
                            if v is not None and v > removed_id:
                                n.p[i] = (k, v - 1)
                        if n.r is not None and n.r > removed_id:
                            n.r -= 1

                # id 정렬
                self.set_id()

            return
        
        # Parent의 parent 찾기
        parent, parent_index = self.find_parent(node)
        if parent is None:
            print("Merge에서 일치하는 Parent를 찾을 수 없습니다.")
            return
            
        left, right = self.find_sibling(node, parent, parent_index)
        
        # 1. Left에서 가져오기
        if left is not None and left.m > (self.b - 1) // 2:
            print("Parent rebuilding: Left")
            lk, lv = left.p.pop(-1)
            old_left_r = left.r         
            left.r = lv                  
            left.m = left.m - 1
            
            # parent의 parent의 ket를 받아온다.
            # Left의 첫번째 key를 parent의 parent의 key로 바꾼다.
            if parent_index > 0 and parent_index - 1 < len(parent.p):
                parent_key, _ = parent.p[parent_index - 1]
                # 부모 internal를 아래 노드로 내릴 때, 그 left_child는 old_left_r 여야 함
                node.p.insert(0, (parent_key, old_left_r))
                # 부모의 internal를 왼쪽에서 가져온 키로 교체
                parent.p[parent_index - 1] = (lk, parent.p[parent_index - 1][1])
            else:
                # parent.r이 node를 가리키는 경우
                node.p.insert(0, (lk, old_left_r))
            
            node.m = node.m + 1
            return
            
        # 2. Right에서 가져오기
        elif right is not None and right.m > (self.b - 1) // 2:
            print("Parent rebuilding: Right")
            rk, rv = right.p[0]
            del right.p[0]
            right.m = right.m - 1
            
            # Right의 첫번째 key를 parent의 parent의 key로 바꾼다.
            if parent_index < len(parent.p):
                parent_key, _ = parent.p[parent_index]
                node.p.append((parent_key, node.r))
                node.r = rv
                # 부모의 internal를 오른쪽에서 가져온 키로 교체
                parent.p[parent_index] = (rk, parent.p[parent_index][1])
            else:
                # parent.r이 right를 가리키는 경우
                node.p.append((rk, node.r))
                node.r = rv
            
            node.m = node.m + 1
            return
            
        # 3. Merge 필요
        if left is not None:
            print("Parent rebuilding: Merge left")
            remove_index = parent_index - 1
            merged_node = self.merge_internal_node(left, node, parent, remove_index)
            if merged_node is not None and not merged_node.is_half_for_internal():
                self.check_parent(merged_node)
        elif right is not None:
            print("Parent rebuilding: Merge right")
            remove_index = parent_index
            merged_node = self.merge_internal_node(node, right, parent, remove_index)
            if merged_node is not None and not merged_node.is_half_for_internal():
                self.check_parent(merged_node)
    
    # 두 Internal node끼리 Merge
    def merge_internal_node(self, left, right, parent, remove_index):
        if remove_index < len(parent.p):
            internal_key, _ = parent.p[remove_index]
            
            left.p.append((internal_key, left.r))
        else:
            # parent.r이 right를 가리키는 경우
            internal_key = None

            left.p.append((internal_key, left.r))
        
        # right의 모든 키를 left에 추가
        left.p.extend(right.p)
        left.r = right.r
        left.m = len(left.p)
        
        # parent에서 internal와 right를 가리키는 포인터 제거
        if remove_index < len(parent.p):
            del parent.p[remove_index]
        else:
            # parent.r이 right를 가리키는 경우
            if remove_index > 0 and remove_index - 1 < len(parent.p):
                del parent.p[remove_index - 1]
            # parent.r은 left.r로 업데이트
            parent.r = left.id
            
        parent.m = len(parent.p)

        new_p = []
        for (k, v) in parent.p:
            if v == right.id:
                new_p.append((k, left.id))
            else:
                new_p.append((k, v))
        parent.p = new_p

        if parent.r == right.id:
            parent.r = left.id
        
        # right를 nodes 배열에서 제거하고 ID 재정렬
        removed_id = right.id
        self.nodes.remove(right)
        
        for n in self.nodes:
            if n.id is not None and n.id > removed_id:
                n.id -= 1

            if n.is_leaf:
                if n.next_leaf_id is not None and n.next_leaf_id > removed_id:
                    n.next_leaf_id -= 1
                if n.r is not None and n.r > removed_id:
                    n.r -= 1
            else:
                n.p = [(k, (v - 1 if v is not None and v > removed_id else v)) for (k, v) in n.p]
                if n.r is not None and n.r > removed_id:
                    n.r -= 1
        
        return parent
    
    # 알맞는 Leaf node를 찾아주는 함수
    def search(self, root, key, is_search): 
        node = root

        while(not node.is_leaf):
            i = node.search(key, is_search) # 다음 Node의 Index
            if i is not None and i < len(self.nodes):
                node = self.nodes[i]
            else:
                break

        return node    

    def single_search(self, key):     
        if len(self.nodes) == 0:
            print("No nodes in the tree")
            return None       
        
        root = self.get_root()

        node = self.search(root, key, True)

        value = node.searchLeaf(key)

        if value == None:
            sys.stdout.write("NOT FOUND" + "\n")
        else:
            sys.stdout.write(str(value) + "\n")

    def ranged_search(self, start_key, end_key):
        if len(self.nodes) == 0:
            print("No nodes in the tree")
            return None  
        
        root = self.get_root()

        node = self.search(root, start_key, False)

        # Linked list로 Leaf node를 탐색
        while(1):
            next_id = node.searchLeaf_for_ranged(start_key, end_key)

            if next_id == None:
                break
            else:
                node = self.nodes[next_id]