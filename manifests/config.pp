# == Class postfixadmin::config
#
# This class is called from postfixadmin
#
class postfixadmin::config {

  if( $::postfixadmin::admin_user != undef or $::postfixadmin::admin_pass != undef ) {

    $admin_hash = dovecot_password( 'cram-md5', $::postfixadmin::admin_user, $::postfixadmin::admin_pass )
  } else {

    $admin_hash = undef
  }


  file { "${::postfixadmin::install_directory}/${::postfixadmin::params::package_name}/config.local.php":
    ensure  => file,
    content => template('postfixadmin/config.local.php.erb'),
  }

  file { "${::postfixadmin::install_directory}/${::postfixadmin::params::package_name}/dba_structure.sql":
    ensure  => file,
    content => template('postfixadmin/dba_structure.sql.erb'),
  }

  file { "${::postfixadmin::install_directory}/${::postfixadmin::params::package_name}/dba_admin.sql":
    ensure  => file,
    content => template('postfixadmin/dba_admin.sql.erb'),
  }



  if( $::postfixadmin::dba_type == 'mysql' ) {

    # TODO: is there a better way?
    exec { 'postfixadmin schema load':
      user    => 'root',
      command => "mysql -h '${::postfixadmin::dba_host}' -u '${::postfixadmin::dba_user}' -p'${::postfixadmin::dba_pass}' '${::postfixadmin::dba_name}' < ${::postfixadmin::install_directory}/${::postfixadmin::params::package_name}/dba_structure.sql && touch ${::postfixadmin::install_directory}/${::postfixadmin::params::package_name}/mysql_schema.loaded",
      creates => "${::postfixadmin::install_directory}/${::postfixadmin::params::package_name}/mysql_schema.loaded",
      onlyif  => "test ! -f ${::postfixadmin::install_directory}/${::postfixadmin::params::package_name}/mysql_schema.loaded",
      require => File[ "${::postfixadmin::install_directory}/${::postfixadmin::params::package_name}/dba_structure.sql" ]
    }

    if( $admin_hash != undef ) {

      exec { 'postfixadmin admin load':
        user    => 'root',
        command => "mysql -h '${::postfixadmin::dba_host}' -u '${::postfixadmin::dba_user}' -p'${::postfixadmin::dba_pass}' '${::postfixadmin::dba_name}' < \"${::postfixadmin::install_directory}/${::postfixadmin::params::package_name}/dba_admin.sql\" && touch \"${::postfixadmin::install_directory}/${::postfixadmin::params::package_name}/mysql_admin.loaded\"",
        creates => "${::postfixadmin::install_directory}/${::postfixadmin::params::package_name}/mysql_admin.loaded",
        onlyif  => "test ! -f ${::postfixadmin::install_directory}/${::postfixadmin::params::package_name}/mysql_admin.loaded",
        require => [
          File[ "${::postfixadmin::install_directory}/${::postfixadmin::params::package_name}/dba_admin.sql" ],
          Exec[ 'postfixadmin schema load' ]
        ]
      }
    }

  } else {

    fail( 'unsorported database' )
  }


}
