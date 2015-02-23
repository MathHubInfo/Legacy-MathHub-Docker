# Docker container for lmh
# (c) The KWARC Group 2015
FROM debian:stable
MAINTAINER Mihnea Iancu <m.iancu@jacobs-university.de>
# make apt-get faster, from https://gist.github.com/jpetazzo/6127116
# this forces dpkg not to call sync() after package extraction and speeds up install
RUN echo "force-unsafe-io" > /etc/dpkg/dpkg.cfg.d/02apt-speedup
# we don't need and apt cache in a container
RUN echo "Acquire::http {No-Cache=True;};" > /etc/apt/apt.conf.d/no-cache
#
# Install all the packages
# This might take a while
#
RUN apt-get update && \
apt-get dist-upgrade -y && \
apt-get install -y python python-dev python-pip git subversion wget tar fontconfig perl cpanminus libxml2-dev libxslt-dev libgdbm-dev openjdk-7-jre-headless && \
apt-get clean
#
# Install lmh itself
# + disable pdflatex support (to avoid texlive)
#
RUN git clone https://github.com/KWARC/localmh $HOME/localmh; \
pip install beautifulsoup4 psutil pyapi-gitlab; \
ln -s $HOME/localmh/bin/lmh /usr/local/bin/lmh; \
lmh config env::pdflatex /bin/false; \
lmh setup --no-firstrun --install all
#
# Installing LAMP and MathHub Deps
#
RUN apt-get install -y mysql-server apache2 php5 php5-mysql libapache2-mod-php5 php5-gd && apt-get clean
RUN git clone https://github.com/KWARC/MathHub /var/www/mathhub.info
ADD mathhub.info /etc/apache2/sites-available/
ADD settings.php /var/www/mathhub.info/sites/default/
RUN chmod 777 /var/www/mathhub.info/sites/default/files
RUN a2enmod rewrite && a2dissite default && a2ensite mathhub.info
RUN service mysql start; mysql -u root -e "create database mathhub;"
ADD start-mh /usr/local/bin/

#
# Setting up basic mathhub stuff (can be overridden locally by mounting folders)
#

#Installing smglom 
RUN mkdir ~/.ssh/ && ssh-keyscan gl.mathhub.info > ~/.ssh/known_hosts
RUN lmh config install::sources "http://gl.mathhub.info/"
RUN lmh config install::nomanifest true
RUN lmh install smglom/mv -y; true
RUN lmh install meta/inf -y; true
RUN lmh install smglom/meta-inf -y; true
RUN cd $(lmh root)/MathHub/ && lmh gen --localpaths 
#RUN cd $(lmh root)/MathHub/ && lmh gen --omdoc
#RUN #(lmh root)/ext/MMT/mmt $(lmh root)/MathHub/build.msl
#Adding dictionary info
ADD dict_data.json ~/localmh/MathHub/
ADD term_links.json ~/localmh/MathHub/

#
# And run the tails command, to do nothing
#
CMD /bin/bash -c "tail -f /dev/null"

