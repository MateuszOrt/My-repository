'''
Given an integer array nums and an integer k, return the k most frequent elements. You may return the answer in any order.

 

Example 1:

Input: nums = [1,1,1,2,2,3], k = 2
Output: [1,2]
Example 2:

Input: nums = [1], k = 1
Output: [1]
 

Constraints:

1 <= nums.length <= 105
-104 <= nums[i] <= 104
k is in the range [1, the number of unique elements in the array].
It is guaranteed that the answer is unique.
 

Follow up: Your algorithm's time complexity must be better than O(n log n), where n is the array's size.'''
#%%
class Solution(object):
    def topKFrequent(self, nums, k):
        dic={}
        i=0
        while len(nums) != i:
            dic[nums[i]]=1 + dic.get(nums[i],0)
            i+=1
        lista=list(dic.values())
        lista.sort()
        L=lista[-k:]
        l=[]
        for k,val in dic.items():
           if val in L:
               l.append(k)
        return l      
        
 
nums = [2,3,4,1,4,0,4,-1,-2,-1]
k=2
s=Solution()
s.topKFrequent(nums, k)        
            
#%%
class Solution:
    def topKFrequent(self, nums: List[int], k: int) -> List[int]:
        count = {}
        freq = [[] for i in range(len(nums) + 1)]

        for n in nums:
            count[n] = 1 + count.get(n, 0)
        for n, c in count.items():
            freq[c].append(n)

        res = []
        for i in range(len(freq) - 1, 0, -1):
            for n in freq[i]:
                res.append(n)
                if len(res) == k:
                    return res

        # O(n)
#%%
nums=[1,1,1,2,2,3]
k= 2
i=0
dic={}
if nums[i] not in dic:
    dic[nums[i]]=1 + dic.get(i,0)

print(dic)
if nums[i] in dic:
    dic[nums[i]]+=1 
print(dic)    