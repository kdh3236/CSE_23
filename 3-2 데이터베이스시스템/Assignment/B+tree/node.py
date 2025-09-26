import sys

class Node:
    def __init__(self, b, node_id: int, is_leaf: int, keys: list, childs: list, next_leaf_id: int = None):
        self.b = b
        self.id = node_id
        self.is_leaf = bool(is_leaf)
        self.next_leaf_id = next_leaf_id
        
        if self.is_leaf:
            self.p_ = list(zip(keys, childs)) if keys else []
            self.p = [] 
            self.r = next_leaf_id
        else:
            self.p = list(zip(keys, childs[:-1])) if keys else []
            self.p_ = []
            self.r = childs[-1] if childs else None
        
        self.m = len(keys) # b-1개여야함

    def is_full(self): # 하나의 (Key, value)를 추가하면 넘치는지 확인한다.
        assert self.m <= self.b-1, "한 Node에 저장될 수 있는 최대 Key의 개수를 초과하였습니다."

        if (self.m == self.b - 1):
            return True
        else:
            return False
        
    def is_half_for_leaf(self): # 하나의 (Key, value)를 삭제하면 Node가 제거되어야 하는지 확인한다.
        if (self.m >= (self.b-1)//2):
            return True
        else:
            return False
        
    def is_half_for_internal(self):
        if (self.m >= ((self.b-1)//2)): # 하나를 삭제했을 때 조건을 만족하는지
            return True
        else:
            return False

    def search(self, key, is_search):
        assert self.is_leaf == 0, "Node.search는 None leaf node에서만 호출되어야 합니다."

        # Single Search인 경우에만 Key 전부 출력
        if is_search:
            keys = [k for k, v in self.p]
            sys.stdout.write(",".join(map(str, keys)) + "\n")

        for k, v in self.p:
            if key < k:
                return v 
        
        return self.r

    def searchLeaf(self, key):
        assert self.is_leaf == 1, "Node.search_in_leaf는 leaf node에서만 호출되어야 합니다."
                
        for k, v in self.p_:
            if key == k:
                return v

        return None
                
    def searchLeaf_for_ranged(self, start_key, end_key):
        assert self.is_leaf == 1, "Node.search_in_leaf는 leaf node에서만 호출되어야 합니다."
                
        for k, v in self.p_:
            if start_key <= k <= end_key: # Including endpoint
                sys.stdout.write(str(k) + "," + str(v) + "\n")
            elif end_key < k: # 해당 Node에서 end_key보다 큰 값이 나왔으면 다음 Node에서 end_key보다 작은 Key 값이 나올 수 없다.
                return None
        
        return self.r # 다음 Leaf Node의 Id 반환
    
    
    def to_string(self):
        key = ','.join(map(str, [pair[0] for pair in (self.p_ if self.is_leaf else self.p)]))
        
        if self.is_leaf:
            child = ','.join(map(str, [pair[1] for pair in self.p_]))
        else:
            child = ','.join(map(str, [pair[1] for pair in self.p]))
            if self.r is not None:
                child += f',{self.r}'
        
        next_leaf_str = str(self.next_leaf_id) if self.next_leaf_id is not None else ''
        
        return f"{self.id}|{int(self.is_leaf)}|{key}|{child}|{next_leaf_str}"