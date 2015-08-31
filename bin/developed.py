#!/usr/bin/env python3

import sys
import os
from glob import glob

project = os.path.basename(sys.argv[1])
glob_path = os.path.join(
    os.environ['HOME'], '.virtualenvs', project,
    'lib/python3.4/site-packages/*.egg-link')

exit(not any([link for link in glob(glob_path)]))
