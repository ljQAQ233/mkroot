cmdcc=$1
specs=$2

cat <<EOF
#!/bin/sh

if [[ -f "$specs" ]]; then
  "$cmdcc" "\$@" -specs=$specs
else
  "$cmdcc" "\$@"
fi
EOF
