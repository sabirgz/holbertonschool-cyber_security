#!/bin/bash
ps -u "$1" -o user,pid,ppid,vsz,rss,tty,stat,start,time,cmd | grep -vE '^\s*[^ ]+\s+[0-9]+\s+[0-9]+\s+0\s+0\s'
