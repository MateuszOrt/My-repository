# Python is a dynamicly typed language
n =0
print('n =', n)
#%%
#Types are tetermined at runtime
n = 'abc'
print('n =', n)
#%%

#Multiple assignments
n, m = 0, 'abc'
#%%
#Increment
n = n + 1
n += 1
#%%
#None is null
n = 4
n = None
print("n =", n)
#%%
#If statements don't need parentheses(nawiasy) or curly braces(nawiasy klamrowe)
# We use indentation(wcięcie)
n=1
if n > 2:
    n -= 1
elif n == 2:
    n *= 2    
#%%
# Parentheses needed for multi-line conditions.  
# and = &&
# or = ||  

n, m = 1, 2
if ((n > 2 and n != m) or n == m):
    n+=1
    print(n)
#%%
n = 0
while n < 5:
    print(n)
    n += 1
    
#%%
for i in range(5):
    print(i)    
    
#%%

for i in range(5,1,-1):
    print(i)
    
#%%

#Division is decimal by deafult
print(5/2)    
# most languages round towards 0

#double slash roudns down
print(5//2)
#deafult so negative numbers will round down
print(-3//2)

#%%

#A workaround for rounding towards zero is to use decimal division and then convert it 
print(int(-3//2))
#%%
#modulo
print(10%3)
#Except for negative values
print(-10%3)
#%%
import math
print(math.fmod(-10, 3))
#%%
print(math.floor(3/2))
print(math.ceil(3/2))
print(math.sqrt(2))
print(math.pow(2,3))
#%%
# inf
float("inf")
float("-inf")
#%%
# Python numbers are infinite so they never overflow
print(math.pow(2,200))
print(math.pow(2,200)<float("inf"))
#%%

arr= [ 1,2,3]
print(arr)

# can be used as a stack
arr.append(4)
arr.append(5)
print(arr)

arr.pop()
print(arr)

arr.insert(1,7)
print(arr)

arr[0]=0
arr[3]=0
print(arr)

#%%
n=5
arr =[1] * 5
print(arr)

#%%
arr=[1,2,3]
print(arr[-1])

# Indexing -2 is the second to last value, etc.
print(arr[-2])
#%%

arr=[1,2,3,4]
print(arr[1:3])

#Similar to for loop ranges, lst index is non-inclusive
print(arr[0:4])

#%%

a,b,c=[1,2,3]
print(a,b,c)

nums = [1,2,3]
for i in range(len(nums)):
    print(nums[i])
    
for i in nums:
    print(i)    
#%%    
for i, n in enumerate(nums):
    print(i, n)    
#%%

#with unpacking
nums1 = [1,3,5]
nums2 = [2,4,6]

for n1,n2 in zip(nums1, nums2): 
    print(n1,n2)
    
#%%

arr= [5, 4, 7, 3, 8]    
arr.sort()
print(arr)
#%%
arr.sort(reverse=True)
print(arr)

#%%
# alhabetical
arr=["bob","alice","jane","doe"]
arr.sort()
print(arr)

# Custom sort (by length of string)
# in this case key is equal to lambda which is a function without a name
# we are going to take every single value from the array call it x and then return from that
# the length of x and this is the key that is going to be used to sort string 
arr.sort(key=lambda x: len(x))
print(arr)
#%%

#List comprehension
arr=[i for i in range(5)]
print(arr)
#%%
arr=[i+i for i in range(5)]
print(arr)

#%%
# 2-d lists 
arr = [[0] * 4 for i in range(4)]
print(arr)

#%%
# if we modify one of the rows we are going to be modifying all of the others
arr= [[0] * 4] * 4
print(arr)
print(arr[0][0])
arr[0][0]=1
print(arr)
#%%
#Strings are similiar to arrays

s="abc"
print(s[0:2])
#%%
#They are immutable(niezmienny)
s[0] = "A"
#%%
s+='def'
print(s)
#%%

#Valid numeric strings can be converted 
print(int("123") + int("123"))

#And numbers can be converted to strings

print(str(123) + str(123))
#%%

# In rare cases you may need the ASCII value of a char
print(ord('a'))
print(ord('b'))

#%%
#Combine a list of strings (with an empty string delimitor)

strings= ['ab','cd','ef']
print("".join(strings))

#%%

#Queues (double ended queue)
from collections import deque
queue = deque()
queue.append(1)
queue.append(2)
print(queue)

#We can do this in a constant time unlike with the stack
queue.popleft()
print(queue)

queue.appendleft(1)
print(queue)

queue.pop()
print(queue)
#%%

#Hash set
#we search them in constant time
#we insert value in constant time
# cant be duplicates
mySet = set()
mySet.add(1)
mySet.add(2)
print(mySet)
print(len(mySet))

print(1 in mySet)

#we can remove values in constant time
mySet.remove(2)
print(2 in mySet)
#%%
#List to set
print(set([1,2,3]))

#Set comprehension
mySet = { i for i in range(5)}
print(mySet)
#%%
#Hash map (aka Dict)
myMap = {}
myMap["alice"]=88
myMap['bob']=77
print(myMap)
print(len(myMap))

myMap['alice']=80
print('alice' in myMap)
myMap.pop('alice')
print('alice' in myMap)

myMap = {"alice":90, "bob":70}
print(myMap)
#%%
#Dict comprehension
myMap = {i: 2*i for i in range(3)}
print(myMap)
#%%
#Looping thru maps
myMap = {"alice":90, "bob":70}
for key in myMap:
    print(key,myMap[key])
    
for val in myMap.values():
    print(val)    
    
for key, val in myMap.items()    :
    print(key,val)
#%%
#Tuples are like arrays but immutable, we use parentheses

tup = (1,2,3)
print(tup)
print(tup[0])
print(tup[-1])
#Can't modify
#tup[0] = 0

#Can be used as key for hash map/set
myMap = {(1,2):3}
print(myMap)
print(myMap[(1,2)])

#We can add typles to hash set
mySet = set()
mySet.add((1,2))
print((1,2) in mySet)
#REason: Lists cant be keys
#myMap{[3,4]: 5}
#%%
#Heaps
import heapq

#under the hood are arrays
minHeap = []
heapq.heappush(minHeap, 3)
heapq.heappush(minHeap, 2)
heapq.heappush(minHeap, 4)

#Min value is always at index 0
print(minHeap[0])
#we can iterate thru heap while it contains values in it
while len(minHeap):
    print(heapq.heappop(minHeap))
#%%
import heapq

#No max heaps by deafult, work around is \
# to use min heap and multiply by -1 when push&pop  
maxHeap=[]
heapq.heappush(maxHeap, -3)
heapq.heappush(maxHeap, -2)
heapq.heappush(maxHeap, -4)
#Max is always at index 0
print(-1 * maxHeap[0])
while len(maxHeap):
    print(-1*heapq.heappop(maxHeap)) 
    
#%%
#Linear time
arr = [2, 1, 8, 4, 5]
heapq.heapify(arr)
while arr:
    print(heapq.heappop(arr))
#%%
def myFunc(n, m):
    return n * m

print(myFunc(3,4))
#%%

#Nested Functions have access to outer variables

def outer(a, b):
    c="c"
    
    def inner():
        return a + b + c
    return inner()

print(outer('a','b'))

#%%

#Can modify objects but not reassign unless using nonlocal keyword

def double(arr,val):
    def helper():
        #Modifying array work
        for i, n in enumerate(arr):
            arr[i] *= 2
            
            #will only modify val in the helper scope
            # val *=2
            
            #this will modify val outside helper scope
            nonlocal val
            val *= 2
    helper()
    print(arr,val)
        
nums = [1,2]
val=3
double(nums, val)        
#%%

class MyClass:
    #Constructor
    def __init__(self, nums):
        #Create member variables
        self.nums = nums
        self.size = len(nums)
        
    #self key word required as param
    def getLength(self): 
        return self.size
    
    def getDoubleLength(self):
        return 2 * self.getLength()