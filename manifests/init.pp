# == Class: postfixadmin
#
# Full description of class postfixadmin here.
#
# === Parameters

class postfixadmin (
  $install_from_source      = $::postfixadmin::params::install_from_source,
  $install_source_version   = $::postfixadmin::params::install_source_version,
  $install_directory        = $::postfixadmin::params::install_directory,
  $admin_domain             = undef,
  $admin_user               = undef,
  $admin_pass               = undef,
  $footer_link              = undef,
  $dba_type                 = $::postfixadmin::params::dba_type,
  $dba_host                 = $::postfixadmin::params::dba_host,
  $dba_user                 = undef,
  $dba_pass                 = undef,
  $dba_name                 = $::postfixadmin::params::dba_name
) inherits postfixadmin::params {

  # validate parameters here

  validate_bool( $install_from_source )
  validate_string( $install_source_version )
  validate_string( $install_directory )
  validate_string( $admin_domain )
  validate_string( $footer_link )
  validate_string( $dba_type )
  validate_string( $dba_host )
  validate_string( $dba_user )
  validate_string( $dba_pass )
  validate_string( $dba_name )

  # -----------------------------------------------------------------------------------

  class { 'postfixadmin::install': } ->
  class { 'postfixadmin::config': } ~>
  Class['postfixadmin']

}

#
