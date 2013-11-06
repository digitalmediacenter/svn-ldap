
sub config(){
  return { 
            # GLOBAL SETTINGS
            'global' => {
             # logfile for the commandline utils 
            'logfile' => "/var/log/apache2/source.foo.bar.de/svn_create_acl_file.log",
             # location of the repositories
             'repository-path' => '/srv/svn/repos/',
             # Loglevel
             'loglevel' => 2,
             # uid and group of the webserver user
             'webserver-uid' => 'www-data',
             'webserver-gid' => 'www-data'
              },
            # SETTINGS for the local directory 
           'directory' => {
                   'hostname'      => '10.1.1.1',
                   'port'          => '389',
                   'scheme'        => 'ldap',
                   'timeout'       => '30',
                   'mgrpass'       => 'passwordofmanager',
                   'mgrdn'         => 'CN=ldap-svn,OU=LDAP,OU=service accounts,OU=administrative,OU=Stuttgart,DC=foobar,DC=local',
                   'basedn'        => 'DC=foobar,DC=local',
                   'group-basedn'  => 'OU=Unix,OU=administrative,OU=Stuttgart,DC=foobar,DC=local',
            },

  }
}

