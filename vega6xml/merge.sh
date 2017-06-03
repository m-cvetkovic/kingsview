#!/bin/bash -e
#
# Create tournaments.xml out of */*.veg tournaments
#
usage() {
    echo "Usage: $0 <output.xml>"
    exit 1
}

[ $# -eq 1 ] || usage

RESULT="$1"

cat >$RESULT <<EOF
<?xml version="1.0" encoding="utf-8"?>
<tournaments>
EOF

for i in */Makefile; do
    dir=$(dirname $i)
    make -C $dir clean +tmp/tournament.xml
    sed '1d
2,$s/^/  /
s/^        /	/' $dir/+tmp/tournament.xml >>$RESULT
done
echo '</tournaments>' >>$RESULT
