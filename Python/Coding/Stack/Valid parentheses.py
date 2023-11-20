'''Given a string s containing just the characters '(', ')', '{', '}', '[' and ']', determine if the input string is valid.

An input string is valid if:

Open brackets must be closed by the same type of brackets.
Open brackets must be closed in the correct order.
Every close bracket has a corresponding open bracket of the same type.
 

Example 1:

Input: s = "()"
Output: true
Example 2:

Input: s = "()[]{}"
Output: true
Example 3:

Input: s = "(]"
Output: false
 

Constraints:

1 <= s.length <= 104
s consists of parentheses only '()[]{}'.'''
#%%
class Solution(object):
    def isValid(self, s):
         for i in range (0,len(s),2):
             if s[i] == '(' and s[i+1] != ')':
                 return False
             if s[i] == '[' and s[i+1] != ']':
                 return False
             if s[i] == '{' and s[i+1] != '}':
                 return False
        
         return True
     
        
     
        
     
        
     
s=Solution()
s.isValid("()(){}]")        

#%%
class Solution(object):
    def isValid(self, s):
         lista=[]
         for i in s:
            lista.append(i)
            
        
         while len(lista) > 0:
             stack=[]
             val=lista.pop()
             print(val,'1')
             if val == '(' or val=='{' or val=='[':
                 stack.append(val)
             else:
                 val2=stack.pop()
                 print(val2,'2')
                 if val2+val == '()' or '[]' or '{}':
                     continue
                 else:
                     return False
         return True
     
        
s=Solution()
s.isValid("()(){}")             
#%%
class Solution(object):
    def isValid(self, s):
        stack=[]
        if len(s)==0 or len(s)==1:
            return False   
        for i in s:          
            if i == '(' or i == '[' or i == '{':
                stack.append(i)       
            else:
                if len(stack) == 0:
                    return False
                else:
                    value=stack.pop()+i
                    if value == '()' or value == '{}' or value == '[]':
                        continue
                    else:
                        return False
        if len(stack) != 0:
             return False
        return True
    
s=Solution()
s.isValid("[[]]")    



#%%
class Solution:
    def isValid(self, s: str) -> bool:
        Map = {")": "(", "]": "[", "}": "{"}
        stack = []

        for c in s:
            if c not in Map:
                stack.append(c)
                continue
            if not stack or stack[-1] != Map[c]:
                return False
            stack.pop()

        return not stack
#%%
stack=[1,2,3,4]
stack.pop()
stack
s=[]
s.append(1)
s.append(2)
s