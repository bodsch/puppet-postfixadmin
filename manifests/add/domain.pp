#

define postfixadmin::add::domain (
  $domain,
  $transport,
  $description = undef,
  $aliases     = 0,
  $mailboxes   = 0,
  $maxquota    = 0,
  $quota       = 0,
  $backupmx    = false,
  $active      = true
) {

  validate_string( $domain )
  validate_string( $description )
  validate_integer( $aliases )
  validate_integer( $mailboxes )
  validate_integer( $maxquota )
  validate_integer( quota )
  validate_string( $transport )
  validate_bool( $backupmx )
  validate_bool( $active )

  # create a domain in postfixadmin

  exec { "add postfixadmin domain ${domain}":
    path    => [ '/bin', '/usr/bin'],
    command => "insert into domain \
       ( domain, description, aliases, mailboxes, maxquota, quota, transport, backupmx, created, modified, active ) values
       ( ${domain}, ${description}, ${aliases}, ${mailboxes}, ${maxquota}, ${quota}, ${transport}, ${backupmx}, now(), now() ${active} ) | \
       mysql -u${postfixadmin::dba_user} -p${postfixadmin::dba_pass} -h ${postfixadmin::dba_host} ${postfixadmin::dba_name} ",
    onlyif  => '/bin/false'

  }


}

