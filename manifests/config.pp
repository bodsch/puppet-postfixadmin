# == Class postfixadmin::config
#
# This class is called from postfixadmin
#
class postfixadmin::config {


  file { "${::postfixadmin::install_directory}/${::postfixadmin::params::package_name}/config.local.php":
    ensure  => file,
    content => template('postfixadmin/config.local.php.erb'),
  }

}
