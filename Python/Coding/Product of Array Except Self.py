'''
Given an integer array nums, return an array answer such that answer[i] is equal to the product of all the elements of nums except nums[i].

The product of any prefix or suffix of nums is guaranteed to fit in a 32-bit integer.

You must write an algorithm that runs in O(n) time and without using the division operation.

 

Example 1:

Input: nums = [1,2,3,4]
Output: [24,12,8,6]
Example 2:

Input: nums = [-1,1,0,-3,3]
Output: [0,0,9,0,0]
 

Constraints:

2 <= nums.length <= 105
-30 <= nums[i] <= 30
The product of any prefix or suffix of nums is guaranteed to fit in a 32-bit integer.
 

Follow up: Can you solve the problem in O(1) extra space complexity? (The output array does not count as extra space for space complexity analysis.)
'''
#%%
import math
class Solution(object):
    def productExceptSelf(self, nums):
        answer=[]
        for i in range(len(nums)):
            l=nums.copy()
            l.remove(nums[i])
            answer.append(math.prod(l))
        return answer            
        
nums = [-1,1,0,-3,3] 
s=Solution()
s.productExceptSelf(nums)
#%%

class Solution(object):
    def productExceptSelf(self, nums):
        answer=[]
        lista=[]
        for i in range(len(nums)):
            l=list(nums)
            l.remove(nums[i])
            lista.append(l)
            
        for j in lista:
            val=1
            for k in j:
                val=val*k
            answer.append(val)
        return answer
nums = nums = [1,2,3,4]  
s=Solution()
s.productExceptSelf(nums)
#%%
class Solution(object):
    def productExceptSelf(self, nums):
        answer=[]
        val=1
        answer.append(1)
        for i in range(len(nums)-1):      
            val=val*nums[i]
            answer.append(val)
        print(answer)  
        post=1
        for i in range(len(nums)-1,-1,-1):
            answer[i]=answer[i]*post
            post=post*nums[i]
        return answer    
           
nums = nums = [1,2,3,4]  
s=Solution()
s.productExceptSelf(nums)
#%%
class Solution:
    def productExceptSelf(self, nums: list[int]) -> list[int]:
        res = [1] * (len(nums))

        for i in range(1, len(nums)):
            res[i] = res[i-1] * nums[i-1]
        postfix = 1
        for i in range(len(nums) - 1, -1, -1):
            res[i] *= postfix
            postfix *= nums[i]
        return res