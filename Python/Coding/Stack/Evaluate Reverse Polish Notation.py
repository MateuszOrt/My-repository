class Solution(object):
    def evalRPN(self, tokens):
        if len(tokens)==1:
            return tokens[0]
        i=0
        while len(tokens) > 1:
            #print(i,tokens)
            if tokens[i] == '+':
               val1 = float(tokens[i-2])
               val2 = float(tokens[i-1]) 
               value=val1+val2
               del tokens[i],tokens[i-1]
               tokens[i-2]=int(value)
               i-=1
            elif tokens[i] == '-':
               val1 = float(tokens[i-2])
               val2 = float(tokens[i-1]) 
               value=val1-val2
               del tokens[i],tokens[i-1]
               tokens[i-2]=int(value)
               i-=1
            elif tokens[i] == '*':
               val1 = float(tokens[i-2])
               val2 = float(tokens[i-1]) 
               value=val1*val2
               del tokens[i],tokens[i-1]
               tokens[i-2]=int(value)
               i-=1
            elif tokens[i] == '/':
               val1 = float(tokens[i-2])
               val2 = float(tokens[i-1]) 
               value=val1/val2
               del tokens[i],tokens[i-1]
               tokens[i-2]=int(value)
               i-=1
            else:  
                i+=1   
            
        return tokens[0]
               
#%%
s=Solution()
s.evalRPN(["10","6","9","3","+","-11","*","/","*","17","+","5","+"])
#%%
class Solution:
    def evalRPN(self, tokens: List[str]) -> int:
        stack = []
        for c in tokens:
            if c == "+":
                stack.append(stack.pop() + stack.pop())
            elif c == "-":
                a, b = stack.pop(), stack.pop()
                stack.append(b - a)
            elif c == "*":
                stack.append(stack.pop() * stack.pop())
            elif c == "/":
                a, b = stack.pop(), stack.pop()
                stack.append(int(float(b) / a))
            else:
                stack.append(int(c))
        return stack[0]