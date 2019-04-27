#!/bin/bash

#Получить IP
APP_IP=$(gcloud compute instances describe 'reddit-app' --zone europe-west1-b --format='get(networkInterfaces[0].accessConfigs[0].natIP)')
DB_IP=$(gcloud compute instances describe 'reddit-db' --zone europe-west1-b --format='get(networkInterfaces[0].accessConfigs[0].natIP)')

#еще вариант, получить список, пробежаться по тегам, объеденить в группы (фильтр хоста по имени из получения списка нужно убрать)
#gcloud compute instances list --filter="name=(reddit-app) AND status:(running) AND zone:(europe-west1-b)" --format="get(networkInterfaces[0].accessConfigs[0].natIP)"
#gcloud compute instances describe 'reddit-db' --zone europe-west1-b --format='get(name, networkInterfaces[0].accessConfigs[0].natIP,tags.items)'

case $1 in
    --list)
        #IP
        cat <<EOF
{
    "db": {
        "hosts": ["reddit-db"]
    },
    "app": {
        "hosts": ["reddit-app"]
    },
    "_meta": {
        "hostvars": {
            "reddit-db": {
                "ansible_host": "$DB_IP"
            },
            "reddit-app": {
                "ansible_host": "$APP_IP"
            }
        }
    }
}
EOF
    ;;
esac
