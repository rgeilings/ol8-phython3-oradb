# ol8thick-phython-oradb
This docker project creates an 'Oracle Linux Server release 8.9' with a thick instant client and Python3, including Python library oracledb.
Using the execQuery.py script it becomes possible to execute a SQL script on a number of predefined Oracle databases.

The prerequisite is that Docker Desktop is installed (for Windows see: https://docs.docker.com/desktop/install/windows-install/).

check out this project in a local director and run docker-compose command.
```
$ pwd
/d/DockerApps/ol8thick-phython3

$ docker-compose up -d
 Network ol8thick-phython_default  Creating
 Network ol8thick-phython_default  Created
 Container ageos_ol8thick-phython  Creating
 Container ageos_ol8thick-phython  Created
 Container ageos_ol8thick-phython  Starting
 Container ageos_ol8thick-phython  Started

Attaching to ageos_ol8thick-phython
```
check if the docker container is running
```
$ docker ps
CONTAINER ID   IMAGE                 COMMAND                  CREATED        STATUS        PORTS                                              NAMES
064dfb9613ba   ageos/ol8             "/bin/bash"              3 weeks ago    Up 27 hours                                                      ageos_ol8thick-phython
```
For example, the script below get_non_default_parameters.sh retrieves all non-standard oracle parameters. The output of this script is the file get_non_default_parameters.txt with all Oracle databases in the Python list 'databases'
```
#!/bin/bash
pushd $(dirname $(readlink -f $0)) > /dev/null

./execQuery.py > $(basename "$0" .sh).txt <<'eof'
select name, value
from v$parameter
where isdefault = 'FALSE'
and value is not null
order by name
eof

popd > /dev/null
```
Go into the container with docker exec -it and run the script. This example uses git bash on Windows, hence winpty.

```
$  winpty docker exec -it ageos_ol8thick-phython //bin//bash
bash-4.4# pwd
/scripts
bash-4.4# ./get_non_default_parameters.sh
```
The beginning of the get_non_default_parameters.txt file looks like this.
```
bash-4.4# head get_non_default_parameters.txt
ORCL|_bct_public_dba_buffer_size|33552384|
ORCL|_fix_control|5520732:off|
ORCL|_optimizer_use_stats_on_conventional_dml|FALSE|
ORCL|audit_file_dest|/u02/app/oracle/admin/ORCL/adump|
ORCL|audit_trail|DB|
ORCL|awr_pdb_autoflush_enabled|TRUE|
ORCL|awr_snapshot_time_offset|1000000|
ORCL|clonedb_dir|/u02/app/oracle/admin/ORCL/scbf|
ORCL|control_file_record_keep_time|30|
ORCL|control_files|+DATAC1(CONTROLFILE)/ORCL/CONTROLFILE/control1.ora, +DATAC1(CONTROLFILE)/ORCL/CONTROLFILE/control2.ora|
bash-4.4#
```

If you want to recreate the docker image you need to download the following files from Oracle (https://www.oracle.com/nl/database/technologies/instant-client/linux-x86-64-downloads.html) and put these in the same directory as the Dockerfile. If you only want to use the ageos/ol8 image, this is not necessary.

`instantclient-sqlplus-linux.x64-21.12.0.0.0dbru.zip`
`instantclient-basic-linux.x64-21.12.0.0.0dbru.zip`
