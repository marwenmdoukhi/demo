#image system avec laquelle on va composer notre contenaire image doit etre existene dans dockerhub
FROM ubuntu:18.10
#le persone responsable de mise a jour de contenaire {optionelle }
LABEL Maintainer="Mdoukhi Marwen marwenmdoukhi@gmail.com"
#idha 9a3d ibuldi fi image w idha talb -y idha sur wla nn  titkrsha build lazmha tfrosi besh iraj3lk 7ata rep noninteractive  a3ml update maghir mt9oli oui w nn 
ENV DEBIAN_FRONTEND noninteractive
#install 
# -yq howa indhflék conasole  
#preparation du système pour l'installation des packages necessaires pour le php
RUN apt-get update && apt-get install software-properties-common -yq
#ajout du repo ondrej pour les extentions php
RUN add-apt-repository ppa:ondrej/php -y && \
	apt-get update -y
#installation des pakages necessaires
RUN apt-get install -yq \
	#haja tb3a system ubunto
	apt-utils \
	#comonde system ta3ml appele web 
	curl \
	#install apache 
	apache2 \
	libapache2-mod-php7.3 \
	#installation php 7.3
	php7.3 \
	#instl les module nessecaire php
	php7.3-cli \
	php7.3-json \
	php7.3-curl \
	#php7.3-fmp \
	php7.3-gd \
	php7.3-ldap \
	php7.3-mbstring \
	php7.3-mysql \
	php7.3-soap \
	php7.3-sqlite3 \
	php7.3-xml \
	php7.3-zip \
	php7.3-intl
RUN apt-get install -yq \
	#logicel de traiement 
	nano \
	#logicel les  fisoaux tompreére de linux 
	locales \
	#utilitaire de telechargment linix
	wget \ 
	#instlation de system de gestion git 
	git \
	#instlation de comprission rar 
	zip \
	#netoage de ficher temp
	&& apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* var/tmp/*
#ajouter  composer symfony ou larvel
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer && \
	#genration des local lungistique
	locale-gen en_US.UTF-8 en_GB.UTF-8 de_DE.UTF-8 es_ES.UTF-8 fr_FR.UTF-8 it_IT.UTF-8 km_KH sv_SE.UTF-8 fi_FI.UTF-8 && \
	#activation de mode rewrite pour apatche pour lecture ficher htaccess 
	a2enmod rewrite expires
#declartion de volume pour docker compose.yml le reconnaise	
VOLUME /var/www/html
#copier le ficher entrypoint de puit host vers image contenaire
COPY entrypoint.sh /usr/local/bin/
#declartion que le ficher entrypont est le point d'entré de notre image contenaire
ENTRYPOINT ["entrypoint.sh"]
#expossion de port 80
EXPOSE 80
#telechrger pma dans le dossier temp & extacté pma puis le copier dans var www & crée lien symoblique (racoursi besh n7iw 4.8.2)
RUN wget -O /tmp/phpmyadmin.tar.gz https://files.phpmyadmin.net/phpMyAdmin/4.8.2/phpMyAdmin-4.8.2-all-languages.tar.gz && \
    tar xfvz /tmp/phpmyadmin.tar.gz -C /var/www && \
    ln -s /var/www/phpMyAdmin-4.8.2-all-languages /var/www/phpmyadmin
#000-d howa confugration ta3 apche normal w defualt.conf howa ficher fih confugration appche w config mt3na  forsito besh ki n7él /phpmyadmin ya9rah w i7élo 
ADD default.conf /etc/apache2/sites-enabled/000-default.conf
#honi win a3mlna config w bdlna ficher besh iwli ya3rfo ficher w config mt3o
ADD config.inc.php /var/www/phpmyadmin 
#php yoltb alik permsion bsh tanjm t5o permsion bsh yta7al phpmyadmin si non i5réjlk erreur de permison
RUN chmod 544 /var/www/phpMyAdmin-4.8.2-all-languages/config.inc.php
#onva declaré que le service princpal de contenare et service apache  bch t5dm apchr
CMD ["apache2ctl", "-D", "FOREGROUND"]


