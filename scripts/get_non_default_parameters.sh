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