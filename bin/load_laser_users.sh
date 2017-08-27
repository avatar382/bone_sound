#!/bin/bash

readonly REMOTE_HOST_URL=cnswww-fablab.arts@glint.osg.ufl.edu
readonly REMOTE_HOST_PATH=/h/cnswww-fablab.arts/fablab.arts.ufl.edu/htdocs
readonly WEB_URL=https://fablab.arts.ufl.edu/load_laser_accounts.php

# SCP CSV file to data.csv on remote host
scp $1 $REMOTE_HOST_URL:$REMOTE_HOST_PATH/data.csv
sleep 2

# launch migration script via browser
open $WEB_URL

