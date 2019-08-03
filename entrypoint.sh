#!/bin/bash
set -euo pipefail
wordpress_initilizing(){
	if [[ -d "/var/www/html" ]]; then
		cd /var/www
		wget https://fr.wordpress.org/latest-fr_FR.zip
		unzip latest-fr_FR.zip
		cd wordpress
		mv * ../html
		echo "[OK] Wordpress seccessfly initilized"
	else
		echo "[NOTICE] Wordpress alrady initilized ..."
	fi
}
if [[ "$1" == apache2* ]]; then
        echo ""
        echo "* SERVER INITIALIZING ... *"
        echo ""
        wordpress_initilizing
		echo ""
        echo "* SERVER STARTED SUCCESSFULY *"
        echo ""
fi
exec "$@"