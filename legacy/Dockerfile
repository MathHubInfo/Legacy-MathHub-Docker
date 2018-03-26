## Dockerfile for the MathHub Drupal Frontend

FROM debian:stretch

## Installing Drupal
## TODO: Use a pre-existing image for this
RUN apt-get update \
    && apt-get install -y apache2 php5 php5-mysql libapache2-mod-php5 php5-gd git \
    && apt-get clean

# Install MathHub into the configuration
RUN git clone https://github.com/KWARC/MathHub /var/www/mathhub.info

# Configuring Apache
ADD mathhub.info /etc/apache2/sites-available/
ADD settings.php /var/www/mathhub.info/sites/default/
RUN chmod 777 /var/www/mathhub.info/sites/default/files && \
    a2enmod rewrite && a2dissite default && a2ensite mathhub.info

# Adding run script
ADD start-mh /usr/local/bin/

#
# Setting up basic mathhub stuff (can be overridden locally by mounting folders)
#

#Installing smglom 
RUN mkdir ~/.ssh/ && ssh-keyscan gl.mathhub.info > ~/.ssh/known_hosts

#RUN #(lmh root)/ext/MMT/mmt $(lmh root)/MathHub/build.msl
#Adding dictionary info
ADD dict_data.json ~/localmh/MathHub/
ADD term_links.json ~/localmh/MathHub/

CMD /bin/bash -c "tail -f /dev/null"