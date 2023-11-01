class Solution(object):
    def groupAnagrams(self, strs):
        
        L=[]
        for i in strs:
            L.append(sorted(i))
        LIST=[]    
        c=[]
        for j in range(len(L)):
            
            if j not in c:
                l=[]
                l.append(j)
                c.append(j)
                for k in range(j,len(L)):
               
                    if L[j] == L[k] and j != k and k not in c:
                    
                        l.append(k)
                        c.append(k)
                        #L.pop(k)
                    
                LIST.append(l)
                
        final=[]
        for i in LIST:
            f=[]  
            for j in i:
                f.append(strs[j])  
            final.append(f)    
        return final
                    
s=Solution()
s.groupAnagrams(["eat","tea","tan","ate","nat","bat"])                
                
                
       
#%%
#Time complexity O(m*nlogn) 
#nlogn for sorting, m is how many input string we have
#Space complexity: O(n)
class Solution(object):
    def groupAnagrams(self, strs):
        strs_dic={}
        
        for i in strs:
            sorted_string =''.join(sorted(i))
            
            if sorted_string not in strs_dic:
                strs_dic[sorted_string]=[]
            strs_dic[sorted_string].append(i)   
        print(strs_dic)
        
        return list(strs_dic.values())
            
       
s=Solution()
s.groupAnagrams(["eat","tea","tan","ate","nat","bat"]) 
#%%
from collections import defaultdict
class Solution(object):
    def groupAnagrams(self, strs):
        strs_dic=defaultdict(list) # deafult value is a list
        for string in strs:
            lista=[0]*26
            for i in string:
                lista[ord(i)-ord('a')]+=1
            strs_dic[tuple(lista)].append(string) # lists cannot be keys, only values can that is wwhy tuple
            
        print(strs_dic)
       
           
        
            
       
s=Solution()
s.groupAnagrams(["eat","tea","tan","ate","nat","bat"])
     