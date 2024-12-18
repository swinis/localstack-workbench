#/bin/bash

docker compose -f docker-compose-documentation.yaml -f docker-compose-enabling.yaml up -d
sleep 30
docker exec -it redmine /config/setup.sh
sleep 30
docker stop redmine && docker start redmine

