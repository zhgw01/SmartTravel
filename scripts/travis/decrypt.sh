#!/bin/sh

echo "=============start to decript=============="
openssl aes-256-cbc -k "$ENCRYPTION_SECRET" -in scripts/profile/SmartTravelInHouse.mobileprovision.enc -d -a -out scripts/profile/SmartTravelInHouse.mobileprovision
openssl aes-256-cbc -k "$ENCRYPTION_SECRET" -in scripts/certs/dist.cer.enc -d -a -out scripts/certs/dist.cer
openssl aes-256-cbc -k "$ENCRYPTION_SECRET" -in scripts/certs/dist.p12.enc -d -a -out scripts/certs/dist.p12

ls -l scripts/certs
echo "password: $KEY_PASSWORD"
