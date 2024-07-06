#/bin/bash

echo 'Enter your LocalStack license code:'
read LOCALSTACK_AUTH_TOKEN

echo $'\n'
echo 'IMPORTANT: As the license is needed for every start of LocalStack, I recommend to append:'
echo '#########'
echo $'\n'
echo 'export LOCALSTACK_AUTH_TOKEN="'$LOCALSTACK_AUTH_TOKEN'"'
echo $'\n'
echo 'to you ~/.bashrc file. '
echo $'\n'

read -p 'Do you wish to start installation (yes|no)?'
if [ "$REPLY" != "yes" ]; then
    echo 'Installation canceled due to user decision'
    exit
fi

echo 'Ok, Lets go for it...'

export LOCALSTACK_AUTH_TOKEN

docker-compose -f docker-compose.yaml up -d
docker-compose -f docker-compose-ci.yaml up -d

echo $'\n'
echo $'\n'
echo 'Setup is finished, you can reach:'
echo '   - Webtop URL:  http://localhost:3000'
echo '   - From within Webtop:'
echo '       - Jenkins URL: http://jenkins:8080 (or use Jenkins Desktop icon in Webtop)'
echo '       - Keycloak URL: http://keycloak:8080 (or use Keycloak Desktop icon in Webtop)'
echo $'\n'
echo 'To finish the setup of Jenkins, open Jenkins URL and use initialAdminPassword as follows:
(The passwordfile will be created while first startup of jenkins, please be patient for another 30 seconds to get it displayed):'
sleep 30
cat ./volumes/jenkins/secrets/initialAdminPassword
