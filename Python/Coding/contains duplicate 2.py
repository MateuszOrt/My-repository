class Solution(object):
    def containsNearbyDuplicate(self, nums, k):
       
        dic = {}
        for i, v in enumerate(nums):
            if v in dic and i - dic[v] <= k:
                return True
            dic[v] = i
        return False
    
s=Solution()
s.containsNearbyDuplicate([1,2,3,4,5,6,7,8,9,9], 3)    
#%%
class Solution(object):
    def containsNearbyDuplicate(self, nums, k):
       
        window = set()
        L=0
        
        for R in range(len(nums)):
            print(R,'R')
            if R - L > k:
                window.remove(nums[L])
                print(nums[L],'L')
                L+=1
                print(nums[R],'nums[R]')
            if nums[R] in window:
                return True
            window.add(nums[R])
        return False    
       
    
s=Solution()
s.containsNearbyDuplicate([1,2,3,4,1,1], 2)  
#%%

dck={1: 0, 2: 1, 3: 2, 4: 3, 5: 4, 6: 5, 7: 6, 8: 7, 9: 8}
print(dck[2])