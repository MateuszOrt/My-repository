class Solution(object):
    def isValidSudoku(self, board):
        for row in board:
            s=set()
            for i in row:
                if i != '.' and i not in s:
                    s.add(i)
                elif i == '.':
                    continue
                else:
                    return False    
            
        for j in range(len(board)):
            S=set()
            for row in board:
                 if row[j] != '.' and row[j] not in S:
                     S.add(row[j])
                 elif row[j] == '.':
                     continue    
                 else:
                     return False    
         
        for h in range(0,9,3):
            for k in range(0,9,3):        
                Set=set()
                for i in range(3):        
                    for j in range(3):
                        if board[h+i][k+j] != '.' and board[h+i][k+j] not in Set:
                            Set.add(board[h+i][k+j])
                        elif board[h+i][k+j] == '.':
                             continue
                        else:
                            return False  
                print(Set)        
                          
        return True            
                    
        
        
        
        
board=[["5","3",".",".","7",".",".",".","."]
,["6",".",".","1","9","5",".",".","."]
,[".","9","8",".",".",".",".","6","."]
,["8",".",".",".","6",".",".",".","3"]
,["4",".",".","8",".","3",".",".","1"]
,["7",".",".",".","2",".",".",".","6"]
,[".","6",".",".",".",".","2","8","."]
,[".",".",".","4","1","9",".",".","5"]
,[".",".",".",".","8",".",".","7","9"]]   

board2=[["8","3",".",".","7",".",".",".","."]
,["6",".",".","1","9","5",".",".","."]
,[".","9","8",".",".",".",".","6","."]
,["8",".",".",".","6",".",".",".","3"]
,["4",".",".","8",".","3",".",".","1"]
,["7",".",".",".","2",".",".",".","6"]
,[".","6",".",".",".",".","2","8","."]
,[".",".",".","4","1","9",".",".","5"]
,[".",".",".",".","8",".",".","7","9"]]

  


board3=[[".",".","4",".",".",".","6","3","."],
 [".",".",".",".",".",".",".",".","."],
 ["5",".",".",".",".",".",".","9","."],
 [".",".",".","5","6",".",".",".","."],
 ["4",".","3",".",".",".",".",".","1"],
 [".",".",".","7",".",".",".",".","."],
 [".",".",".","5",".",".",".",".","."],
 [".",".",".",".",".",".",".",".","."],
 [".",".",".",".",".",".",".",".","."]]

board4=[[".",".",".",".","5",".",".","1","."],
        [".","4",".","3",".",".",".",".","."],
        [".",".",".",".",".","3",".",".","1"],
        ["8",".",".",".",".",".",".","2","."],
        [".",".","2",".","7",".",".",".","."],
        [".","1","5",".",".",".",".",".","."],
        [".",".",".",".",".","2",".",".","."],
        [".","2",".","9",".",".",".",".","."],
        [".",".","4",".",".",".",".",".","."]]

s=Solution()
s.isValidSudoku(board)     

#%%
import collections

class Solution2:
    def isValidSudoku2(self,board):
        cols =collections.defaultdict(set)
        rows = collections.defaultdict(set)
        squares = collections.defaultdict(set)

        for r in range(9):
            for c in range(9):
                if board[r][c] == ".":
                    continue
                if (board[r][c] in rows[r]
                    or board[r][c] in cols[c]
                    or board[r][c] in squares[(r // 3, c // 3)]):
                    return False
                cols[c].add(board[r][c])
                rows[r].add(board[r][c])
                squares[(r // 3, c // 3)].add(board[r][c])

        return True

s=Solution2()
s.isValidSudoku2(board)  
#%%d={}
d['Apple']=50
d['Orange']=20
print(d['Apple'])
print(d['Grapes'])# This gives Key Error
We can avoid this KeyError by using defaulting in normal dict as well, let see how we can do it

d={}
d['Apple']=50
d['Orange']=20
print(d['Apple'])
print(d.get('Apple'))
print(d.get('Grapes',0)) # DEFAULTING
Using default dict

from collections import defaultdict
d = defaultdict(int) ## inside parenthesis we say what should be the default value.
d['Apple']=50
d['Orange']=20
print(d['Apple'])
print(d['Grapes']) ##→ This gives Will not give error