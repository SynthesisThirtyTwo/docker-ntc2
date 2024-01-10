#!/bin/bash

set -x

cd /data

if ! [[ "$EULA" = "false" ]]; then
	echo "eula=true" > eula.txt
else
	echo "You must accept the EULA to install."
	exit 99
fi

if ! [[ -f Not+Too+Complicated2-1.5.1-server.zip ]]; then
  rm -fr config defaultconfigs scripts forge-*.jar start.sh *Server.zip
	curl -Lo Not+Too+Complicated2-1.5.1-server.zip 'https://mediafilez.forgecdn.net/files/3957/451/Not+Too+Complicated2-1.5.1-server.zip' && unzip -u -o 'Not+Too+Complicated2-1.5.1-server.zip' -d /data
fi

if ! [[ -f NTC2-TechniParc-Addon.zip ]]; then
  rm -fr config defaultconfigs scripts forge-*.jar start.sh *Server.zip
	curl -Lo NTC2-TechniParc-Addon.zip 'https://onedrive.live.com/?redeem=aHR0cHM6Ly8xZHJ2Lm1zL3UvcyFBbjlpd3JaR3pZbUtsUnV0NzJGTjBqRWtNLTZOP2U9aW9VaUEy&cid=8A89CD46B6C2627F&id=8A89CD46B6C2627F%212715&parId=8A89CD46B6C2627F%21454&o=OneUp' && unzip -u -o 'NTC2-TechniParc-Addon.zip' -d /data
fi

if [[ -n "$OPS" ]]; then
    echo $OPS | awk -v RS=, '{print}' > ops.txt
fi

sed -i 's/server-port.*/server-port=25565/g' server.properties

if [[ -f start.sh ]]; then
  chmod +x start.sh
  ./start.sh
else
  FORGE_JAR=$(ls forge-*.jar)
  java -server -XX:+UseG1GC -XX:+UnlockExperimentalVMOptions -Dfml.queryResult=confirm $JAVA_OPTS -jar $FORGE_JAR nogui
fi
