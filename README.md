svn-ldap
========

svn-ldap - svn permissions managed by ldap/microsoft active directory


## Installation

* Apache installation
  ```
apt-get install apache2 apache2-mpm-prefork apache2-utils libapache2-svn libapache2-mod-php5 perl libnet-ldap-perl
  ```
* Directory creation
  ```
mkdir /srv/scripts/ /srv/svn/repos/ /var/log/apache2/svn.foobar.de/ /srv/www/svn.foobar.de
chown www-data:www-data /srv/scripts/ /srv/svn/repos/ /var/log/apache2/svn.foobar.de/ /srv/www/svn.foobar.de
  ```
* Install the tools
  ```
git clone git@github.com:digitalmediacenter/svn-ldap.git
  ```
* Configure the permission_generator
  ```
vim /srv/scripts/svn-ldap/conf/svntools-config.pl
  ```
* Configure ldap acls
  ```
vim /srv/scripts/svn-ldap/conf/svnaccess_template
  ```
* Configure apache (change paths and ldap credentials)
  ```
touch /srv/scripts/svn-ldap/conf/userdb
chown www-data:www-data /srv/scripts/svn-ldap/conf/userdb
ln -s /srv/scripts/svn-ldap/conf/apache-vhost.conf /etc/apache2/sites-enabled/svn.conf
vim /etc/apache2/sites-enabled/svn.conf
  ```
* add a cronjob for automatic acl creation
  echo "*/15 * * * root /srv/scripts/svn-ldap/permission_generator/svn_create_acl_file /srv/scripts/svn-ldap/conf/svnaccess_template --target=/srv/scripts/svn-ldap/conf/svnaccess" > /etc/cron.d/svn

