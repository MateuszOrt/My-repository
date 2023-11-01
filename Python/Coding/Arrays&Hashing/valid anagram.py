class Solution(object):
    def isAnagram(self, s, t):
      
        S=sorted(s)
        T=sorted(t)
        print(S)
        print(T)
        if S == T:
            return True
        return False
        
s=Solution()
s.isAnagram('anagram{78', '{nag87aram')        
#%%

class Solution(object):
    def isAnagram(self, s, t):
        if len(s) != len(t):
            return False
        dic1={}
        dic2={}
        for i in s:
            dic1[i]=1 + dic1.get(i,0)
            print(i,dic1[i])
        for i in t:
            dic2[i]=1 + dic2.get(i,0) 
            #print(i,dic2[i])
        for j in dic1:
            if dic1[j] != dic2.get(j,0):
                return False
        return True    
s=Solution()
s.isAnagram('anagram{79', '{nag87aram')      






#%%


x='abcd'
y='dbac'
X=sorted(x)
Y=sorted(y)
print(X,Y)
print(X is Y)
if X == Y:
    print('true')