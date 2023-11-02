'''Given an unsorted array of integers nums, return the length of the longest consecutive elements sequence.

You must write an algorithm that runs in O(n) time.

 

Example 1:

Input: nums = [100,4,200,1,3,2]
Output: 4
Explanation: The longest consecutive elements sequence is [1, 2, 3, 4]. Therefore its length is 4.
Example 2:

Input: nums = [0,3,7,2,5,8,4,6,0,1]
Output: 9
 

Constraints:

0 <= nums.length <= 105
-109 <= nums[i] <= 109'''
#%%
class Solution(object):
    def longestConsecutive(self, nums):
        Set=set(nums)
        lista=list(Set)
        lista.sort()
        print(lista)
        licz=1
        if len(lista) == 0:
            zapis = 0
        else:
            zapis=1
        for i in range(len(lista)-1):
            if lista[i]+1==lista[i+1]:
                licz+=1
            if licz>zapis:
                zapis=licz
            elif lista[i]+1!=lista[i+1]:
                licz=1
        return zapis    




s=Solution()
s.longestConsecutive([9,1,4,7,3,-1,0,5,8,-1,6])

#%%

class Solution(object):
    def longestConsecutive(self, nums):
        Set=set(nums)
        save=0
        for j in Set:
            if j-1 not in Set:
                length=1  
                plus = j+1
                while plus in Set:
                    length+=1
                    plus+=1
                if length>save:
                    save=length
            else:length=1
        return save
        





a=[100,4,200,1,3,2]
b=[9,1,4,7,3,-1,0,5,8,-1,6]
c=[0,3,7,2,5,8,4,6,0,1]
s=Solution()
s.longestConsecutive(c)
#%%

class Solution:
    def longestConsecutive(self, nums: List[int]) -> int:
        numSet = set(nums)
        longest = 0

        for n in numSet:
            # check if its the start of a sequence
            if (n - 1) not in numSet:
                length = 1
                while (n + length) in numSet:
                    length += 1
                longest = max(length, longest)
        return longest
