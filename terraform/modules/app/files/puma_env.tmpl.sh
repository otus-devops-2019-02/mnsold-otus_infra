#!/bin/bash

#переменные передаются в: data "template_file" "name" { ...
echo "set DATABASE_URL=${database_url}"
cat > /home/appuser/puma_env.conf << EOF
#puma conf
DATABASE_URL=${database_url}
EOF
