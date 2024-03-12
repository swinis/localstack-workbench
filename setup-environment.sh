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

docker-compose up -d

echo $'\n'
echo $'\n'
echo 'Setup is finished, you can reach:'
echo '   - Webtop URL:  http://localhost:3000'
echo '   - Jenkins URL: http://localhost:8080 (or use Jenkins Desktop icon in Webtop)'
echo $'\n'
echo 'To finish the setup of Jenkins, open Jenkins URL and use initialAdminPassword as follows:'
cat ./volumes/jenkins/secrets/initialAdminPassword
