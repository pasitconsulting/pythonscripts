#!/bin/bash

#dump contents of postgres databases
/usr/bin/pg_dumpall > /opt/postgresqlbkdumps/postgresbackup`date +\%d%m%y_%M%S`

#upload backup to skyscapestorage
/opt/scripts/api-filecreate.sh
