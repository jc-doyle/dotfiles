#!/usr/bin/python
import subprocess

sites = { 
    'compsci':'https://vula.uct.ac.za/dav/25e89dc6-6c5e-4824-81ca-7d63e50bac31',
    'stats':'https://vula.uct.ac.za/dav/4f324a83-f632-4e1e-b0dd-29e1a4691268',
    'maths':'https://vula.uct.ac.za/dav/c6dbbcf3-052a-4c55-babe-a4a0fcd9f831',
    'research':'https://vula.uct.ac.za/dav/9cc926cf-d9be-433e-a99f-dce0c849a511',
    'compsci/tutoring':'https://vula.uct.ac.za/dav/69a31d79-612f-4d8c-8338-c378e192af04',
}

for dir, site in sites.items():
    process = subprocess.run(['sudo', 'mount', '-t', 'davfs', site, '/home/jonty/university/'+dir+'/vula'])
    if process.returncode == 0: print('Mounted ' + dir + '.')

# Update "/etc/davfs2/secrets" for auto-authentication
