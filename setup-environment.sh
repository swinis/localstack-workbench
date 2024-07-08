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

echo 'Ok, then - go, go, go ...'

export LOCALSTACK_AUTH_TOKEN

# workaround to get aws-cli installed on webtop, as downloading from within container
# does no work with the latest version of webtop:ubuntu-kde

mkdir -p ./volumes/webtop/Downloads/
curl "https://awscli.amazonaws.com/awscli-exe-linux-aarch64.zip" -o "./volumes/webtop/Downloads/awscliv2.zip"

docker-compose -f docker-compose.yaml up -d
docker-compose -f docker-compose-enabling.yaml up -d
docker-compose -f docker-compose-ci.yaml up -d

echo $'\n'
echo $'\n'
echo 'Setup is finished, you can access:'
echo '   - Webtop URL:  http://localhost:3000'
echo '   - From within Webtop:'
echo '       - Jenkins URL: http://jenkins:8080 (or use Jenkins Desktop icon in Webtop)'
echo '       - Keycloak URL: http://keycloak:8080 (or use Keycloak Desktop icon in Webtop)'
echo $'\n'
echo 'To finish the setup of Jenkins, open Jenkins URL and use initialAdminPassword as follows:
(The passwordfile will be created while first startup of jenkins, please be patient for another 30 seconds to get it displayed):'
sleep 30
cat ./volumes/jenkins/secrets/initialAdminPassword
