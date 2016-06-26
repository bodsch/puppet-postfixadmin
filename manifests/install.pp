# == Class postfixadmin::install
#
class postfixadmin::install {
#  include postfixadmin::params

  $install_from_source      = $::postfixadmin::install_from_source
  $install_source_version   = $::postfixadmin::install_source_version

  $full_package_name        = "${::postfixadmin::package_name}-${::postfixadmin::install_source_version}.tar.gz"
  $package_source           = "http://downloads.sourceforge.net/project/${::postfixadmin::package_name}/${::postfixadmin::package_name}/${::postfixadmin::package_name}-${::postfixadmin::install_source_version}/${full_package_name}"


  if( $install_from_source == true ) {

      # the debian package has a hard depends to apache2 (WHAT THE FUCK UP!)
      # okay, we install our package from source
      staging::deploy { $full_package_name:
        source  => $package_source,
        target  => $::postfixadmin::install_directory,
        require => File[ $::postfixadmin::install_directory ]
      }

      file { "${::postfixadmin::install_directory}/${::postfixadmin::params::package_name}":
        ensure  => link,
        target  => "${::postfixadmin::install_directory}/${::postfixadmin::params::package_name}-${::postfixadmin::install_source_version}",
        require => Staging::Deploy[ $full_package_name ]
      }

  } else {

    package { $postfixadmin::params::package_name:
      ensure          => present,
      install_options => ['--no-install-recommends'],
    }
  }


}
