#!/usr/bin/python
#
#    lab_datagen: script to generate lab assignment data
#
#    FOLLOW THE COMMENTS IN CAPITALS BELOW TO EDIT THIS SCRIPT FOR A NEW QUIZ

import math
import random

#
#ADD VARIABLES HERE
#
var = {
    "R1" : 1000,
    "R2" : 10000,
    "R3" : 10000,
    "R4" : 100,
    "V_C" : 5,
    "A_I" : 1,
    "phi" : 30.0/180*math.pi,
    "fx" : 1000,
    "X" : -1/(2*math.pi*1000*3.0e-6),
    "k" : 100
}

def printData(var):
    for i in range(len(var)):
        print str(var.keys()[i])+"="+str(var.values()[i])

def genData(number):
    random.seed(number)
    tol = 5.0
    var_used = var
    for i in range(len(var)):
        var_used[var.keys()[i]] += random.uniform(-tol/100, tol/100)*var.values()[i]
    return var_used

def main():
    #init test
    number = input("\n\nPlease enter your student number: \n")

    meth = bool(random.getrandbits(1))
    if meth:
        print "\n\n\nUSE THE MESH METHOD"
    else:
        print "\n\n\nUSE THE NODE METHOD"

    dep_type = bool(random.getrandbits(1))
    if dep_type:
        print "x = I(R_3)"
    else:
        print "x = V(R_3)"

    print
    print
    var_used = genData(number)
    printData(var_used)
    
if __name__ == "__main__": main()


