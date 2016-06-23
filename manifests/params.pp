# == Class postfixadmin::params
#
# This class is meant to be called from postfixadmin
# It sets variables according to platform
#
class postfixadmin::params {

  $package_name             = 'postfixadmin'

  $install_from_source      = false
  $install_source_version   = '2.90'
  $install_directory        = '/var/www'

  $dba_name                 = 'postfix'

}

#

