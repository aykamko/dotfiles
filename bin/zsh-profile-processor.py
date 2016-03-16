#!/usr/bin/env python
import argparse
import fileinput
import re
import heapq

parser = argparse.ArgumentParser(description='Process output from ZSH profiler.')
parser.add_argument('zsh_start_time', type=float)
parser.add_argument('profiler_output')
args = parser.parse_args()

time_re = re.compile('^\+(\d+\.\d+) (.*)')

sorted_lines = []

zsh_start_time = args.zsh_start_time
prev_line = '<starting shell>'
prev_time = zsh_start_time
for line in fileinput.input(args.profiler_output, inplace=True):
    match = time_re.match(line)
    if not match:
        print line,
        continue

    cur_line = match.group(2)
    cur_time = float(match.group(1))

    cumulative_time = cur_time - zsh_start_time
    line_time = cur_time - prev_time

    print '+%011.8f [%011.8f] %s' % (cumulative_time, line_time, cur_line)

    heapq.heappush(sorted_lines, (-line_time, prev_line))

    prev_time = cur_time
    prev_line = cur_line

# print 25 longest running lines to another file
with open(args.profiler_output + '_max', 'w') as f:
    for _ in range(25):
        time, line = heapq.heappop(sorted_lines)
        time = (-time * 1000)
        f.write('%011.8f: %s\n' % (time, line))
        if not len(sorted_lines):
            break
