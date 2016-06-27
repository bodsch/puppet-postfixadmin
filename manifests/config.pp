# == Class postfixadmin::config
#
# This class is called from postfixadmin
#
class postfixadmin::config {

  $admin_user   = $::postfixadmin::admin_user
  $admin_pass   = $::postfixadmin::admin_pass
  $dba_type     = $::postfixadmin::dba_type
  $dba_host     = $::postfixadmin::dba_host
  $dba_user     = $::postfixadmin::dba_user
  $dba_pass     = $::postfixadmin::dba_pass
  $dba_name     = $::postfixadmin::dba_name

  $install_dir  = $::postfixadmin::install_directory
  $package_name = $::postfixadmin::params::package_name


  if( $::postfixadmin::admin_user != undef or $::postfixadmin::admin_pass != undef ) {

    $admin_hash = dovecot_password( 'cram-md5', $::postfixadmin::admin_user, $::postfixadmin::admin_pass )
  } else {

    $admin_hash = undef
  }


  file { "${install_dir}/${package_name}/config.local.php":
    ensure  => file,
    content => template('postfixadmin/config.local.php.erb'),
  }

  file { "${install_dir}/${package_name}/dba_structure.sql":
    ensure  => file,
    content => template('postfixadmin/dba_structure.sql.erb'),
  }

  file { "${install_dir}/${package_name}/dba_admin.sql":
    ensure  => file,
    content => template('postfixadmin/dba_admin.sql.erb'),
  }



  if( $dba_type == 'mysql' ) {

    # TODO: is there a better way?
    exec { 'postfixadmin schema load':
      path    => ['/usr/bin', '/usr/sbin', '/bin'],
      user    => 'root',
      command => "mysql -h '${dba_host}' -u '${dba_user}' -p'${dba_pass}' '${$dba_name}' < \
                  ${install_dir}/${package_name}/dba_structure.sql && \
                  touch ${install_dir}/${package_name}/mysql_schema.loaded",
      onlyif  => "test ! -f '${install_dir}/${package_name}/mysql_schema.loaded'",
      require => File[ "${install_dir}/${package_name}/dba_structure.sql" ]
    }

    if( $admin_hash != undef ) {

      exec { 'postfixadmin admin load':
        user    => 'root',
        path    => ['/usr/bin', '/usr/sbin', '/bin'],
        command => "mysql -h '${dba_host}' -u '${dba_user}' -p'${dba_pass}' '${$dba_name}' < \
                    ${install_dir}/${package_name}/dba_admin.sql && \
                    touch ${install_dir}/${package_name}/mysql_admin.loaded",
        onlyif  => "test ! -f ${install_dir}/${package_name}/mysql_admin.loaded",
        require => [
          File[ "${install_dir}/${package_name}/dba_admin.sql" ],
          Exec[ 'postfixadmin schema load' ]
        ]
      }
    }

  } else {

    fail( 'unsorported database' )
  }


}
