lista=[1,2,3,3]
t=(lista)
mySet = { i for i in lista}
print(mySet)
if len(mySet) != len(lista):
     True
#%%
class Solution(object):
    def containsDuplicate(self, nums):
        
        mySet = { i for i in nums}
        if len(mySet) != len(nums):
            return True
        else:
            return False    
    def containsDuplicate2(self,nums):
        return len(set(nums)) != len(nums)  
    def containsDuplicate3(self,nums):
        hashset=set()
        
        for n in nums:
            if n in hashset:
                return True
            hashset.add(n)
        return False    

s=Solution()
s.containsDuplicate3([1,2,3])