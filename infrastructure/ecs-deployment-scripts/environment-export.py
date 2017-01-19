#!/usr/bin/env python

import fileinput
import json
import os

output_type = os.getenv('OUTPUT', 'exports')

data = "".join([l.strip('\n') for l in fileinput.input()])

docker_environment = ""

environment = json.loads(data).get('environment')

cmd = [ 'export %s="%s"\n' % (key,value) for key,value in environment.iteritems() ]
docker_environment = [ ' -e %s="%s"' % (key,value) for key,value in environment.iteritems() ]
port = environment['PORT']

if ( output_type == "docker" ):
   print "{} -p {}:{}".format("".join(docker_environment), port, port)
else:
   print "".join(cmd)
