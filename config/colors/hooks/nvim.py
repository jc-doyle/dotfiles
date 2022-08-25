#!/bin/python

import subprocess

cmd = ['nvr', '--nostart', '--serverlist']
process = subprocess.run(cmd, stdout=subprocess.PIPE)
servers = process.stdout.decode().split('\n')

for server in servers:
    if len(server) > 0:
        str = "so ~/.config/nvim/lua/highlight.lua"
        cmd = ['nvr', '--nostart', '--servername', server, '-cc', str]
        process = subprocess.run(cmd, stdout=subprocess.PIPE)
