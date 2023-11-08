"""

Design an algorithm to encode a list of strings to a string.
The encoded string is then sent over the network and is decoded back to the original list of strings.

Please implement encode and decode

Example1

Input: ["lint","code","love","you"]
Output: ["lint","code","love","you"]
Explanation:
One possible encode method is: "lint:;code:;love:;you"

Example2

Input: ["we", "say", ":", "yes"]
Output: ["we", "say", ":", "yes"]
Explanation:
One possible encode method is: "we:;say:;:::;yes"

"""

#%%

class Solution:
    """
    @param: strs: a list of strings
    @return: encodes a list of strings to a single string.
    """
    def encode(self, strs):
        string=':'
        for i in strs:
            string=string+i+':'
        return string  
    """
    @param: str: A string
    @return: decodes a single string to a list of strings
    """
    def decode(self, string):
        lista=[]
        i=0
        while len(string) != 0:
            if string[i] == ':':
                string = string.replace(string[i],'',1)
                if len(string) == 0:
                    break
                slowo=''
                while string[i] != ':':
                    slowo=slowo+string[i]
                    string = string.replace(string[i],'',1)
                lista.append(slowo)
        return lista     
                
 
    
 
lista=["lint","code","love","you"] 
s=Solution()
enc=s.encode(lista) 
s.decode(enc)   

#%%

class Solution:
    """
    @param: strs: a list of strings
    @return: encodes a list of strings to a single string.
    """
    def encode(self, strs):
        string=''
        for i in strs:
            string=string+str(len(i))+'#'+i
        return string  
    """
    @param: str: A string
    @return: decodes a single string to a list of strings
    """
    def decode(self, string):
        lista=[]
        j=0
        while len(string) != 0:
            slowo=''
            print(string)
            for i in range(int(string[j])):
                slowo=slowo+string[i+2]
            string=string[int(string[j])+2:] 
            lista.append(slowo)
        return lista
    
lista2=["we", "say", ":", "yes"]   
lista=["lint","code","love","you"]    
s=Solution()
enc=s.encode(lista2) 
s.decode(enc)   







#%%

# a='halo'
# a.replace(a[0],'')
# b=''
# len(b)
# j=':lint:code:love:you'
# j=j.replace(j[0],'',1)
# print(j)
# j=j.replace(j[0],'',1)

# print(j)

#i=0
string='4#lint4#code4#love3#you'
#print(int(x[0])+int(x[6]))
string=string[int(string[i])+2:] 
string