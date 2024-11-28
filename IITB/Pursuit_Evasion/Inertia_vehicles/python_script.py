import os
import numpy as np

os.system('./phc -b multilin new')
new_file = open("new").readlines()

i = 0
root = []
for line in new_file:
    if line[:5] == " x : " :
        exp = float(line[23:26])
        mantissa = float(line[5:22])
        print(mantissa)
        print (mantissa*10**exp)

        i += 1
    
