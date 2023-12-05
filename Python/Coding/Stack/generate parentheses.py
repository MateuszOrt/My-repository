class Solution(object):
    def generateParenthesis(self, n):
        lista=[]
        res=[]
        
        def step(opened,closed):
           if opened==closed==n:
                print('przed','opened=n=closed',lista)
                res.append(''.join(lista))
                print('po','opened=n=closed',lista)
                return 
           
           if opened>closed:
              lista.append(')')
              print('przed','opened>closed',lista)
              step(opened,closed+1)
              print('po','opened>closed',lista)
              lista.pop()
           if opened<n:
               lista.append('(')
               print('przed','opened<n',lista)
               step(opened+1,closed)
               print('po','opened<n',lista)
               lista.pop()
               
        step(0,0)
        return res
#%%

s=Solution()
s.generateParenthesis(2)               
#%%
class Solution(object):
    def generateParenthesis(self, n):
            
            res = []
            
            def backtrack(open_n, closed_n, path):
                
    
                if open_n == closed_n == n:
                    res.append(path)
                    return
                
    
                if open_n < n:
                    backtrack(open_n + 1, closed_n, path + "(")
                 
    
                if closed_n < open_n:
                    backtrack(open_n, closed_n + 1, path + ")")
                    
            backtrack(0, 0, "")
            return res
        
s=Solution()
s.generateParenthesis(2)