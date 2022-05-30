#!/bin/bash
brew install jq
PS3='Please enter your choice: '
options=("vault-prod" "vault-staging" "quit")
select opt in "${options[@]}"
do
    case $opt in
        "vault-prod")
            echo "you chose $opt"
            VAULT_URL="https://vault.internalk.com:8200/v1/auth/okta/login"
            break
            ;;
        "vault-staging")
            echo "you chose $opt"
            VAULT_URL="https://vault-staging.internalk-stg.com:8200/v1/auth/okta/login"
            break
            ;;
        "quit")
            exit
            ;;
        *) echo "invalid option $REPLY";;
    esac
done

USERNAME=$(whoami)
read -sp "please enter password: " PASSWORD
TOKEN=$(curl -s --request POST --data "{\"password\": \"${PASSWORD}\"}" "${VAULT_URL}"/"${USERNAME}" | jq -r .auth.client_token)
echo -e "\nYour token is: $TOKEN"
echo $TOKEN > ~/.vault-token
perl -p -i -e 's/\R//g;' ~/.vault-token
