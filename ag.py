#! /usr/bin/env python
import numpy as np
import sys, argparse

parser = argparse.ArgumentParser()
parser.add_argument('-t', type=str, default='')
args = parser.parse_args()

arr = list(map(float, sys.stdin.readlines()))
if args.t:
  arr = [eval(args.t) for a in arr]
print('mean / sd / ci / n', np.mean(arr), np.std(arr), np.std(arr)/(len(arr)-1)**0.5*1.96, len(arr))
print('p50/25/75', np.percentile(arr, [50,25,75]))
