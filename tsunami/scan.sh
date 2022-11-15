#!/bin/bash

cd /root/tsunami
for i in $ip;
do
  java -cp "tsunami-main-0.0.15-SNAPSHOT-cli.jar:/root/tsunami/plugins/*" -Dtsunami-config.location=/root/tsunami/tsunami.yaml com.google.tsunami.main.cli.TsunamiCli --ip-v4-target=$i --scan-results-local-output-format=JSON --scan-results-local-output-filename=/scanner/records/tsunami-output-$i.json
done
