#!/usr/bin/env python
import argparse
import fileinput
import re
import os

parser = argparse.ArgumentParser(description='Process output from ZSH profiler.')
parser.add_argument('zsh_start_time', type=float)
parser.add_argument('profiler_output')
args = parser.parse_args()

time_re = re.compile('^\+(\d+\.\d+) (.*)')

zsh_start_time = args.zsh_start_time
last_time = zsh_start_time
for line in fileinput.input(args.profiler_output, inplace=True):
    match = time_re.match(line)
    if not match:
        print line,
        continue
    cur_time = float(match.group(1))
    print '+%011.8f [%011.8f] %s' % (cur_time - zsh_start_time, cur_time - last_time,
                                     match.group(2))
    last_time = cur_time
