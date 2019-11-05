#! /usr/bin/env python
import numpy
import sys
a = list(map(float, sys.stdin.readlines()))
print(numpy.mean(a), numpy.std(a), numpy.std(a)/(len(a)-1)**0.5)
