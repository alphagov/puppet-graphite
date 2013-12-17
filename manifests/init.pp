# == Class: graphite
#
# Class to install and configure the Graphite metric aggregation and
# graphing system.
#
# === Parameters
#
# [*admin_password*]
#   The (hashed) initial admin password.
#
# [*port*]
#   The port on which to serve the graphite-web user interface.
#
# [*root_dir*]
#   Where to install Graphite.
#
# [*gr_user*]
#   User to use for owner of graphite and carbon files/directories.
#
# [*gr_group*]
#   Group to use for owner of graphite and carbon files/directories.
#
# [*storage_aggregation_content*]
#   Optional: the content of the storage-aggregation.conf file.
#
# [*storage_aggregation_source*]
#   Optional: the source of the storage-aggregation.conf file.

# [*storage_schemas_content*]
#   Optional: the content of the storage-schemas.conf file.
#
# [*storage_schemas_source*]
#   Optional: the source of the storage-schemas.conf file.
#
# [*carbon_conf_content*]
#   Optional: the content of the carbon.conf file.
#
# [*carbon_conf_source*]
#   Optional: the source of the carbon.conf file.
#
# [*django_secret_key*]
#   Optional: SECRET_KEY setting in local_settings.py for graphite.
#
# [*django_timezone*]
#   Optional: TIME_ZONE setting in local_settings.py for graphite.
#
# [*smtp_server*]
#   Optional: SMTP_SERVER setting in local_settings.py for graphite.
#
# [*use_ldap_auth*]
#   Optional: Enable LDAP authentication for graphite.
#
# [*ldap_server*]
#   Optional: LDAP server for graphite LDAP authentication.
#
# [*ldap_port*]
#   Optional: LDAP server port.
#
# [*ldap_search_base*]
#   Optional: LDAP search base.
#
# [*ldap_base_user*]
#   Optional: LDAP base user.
#
# [*ldap_base_pass*]
#   Optional: LDAP base password.
#
# [*ldap_user_query*]
#   Optional: LDAP user query.
#   For Active Directory use "(sAMAccountName=%s)"
class graphite(
  $admin_password = $graphite::params::admin_password,
  $port = $graphite::params::port,
  $root_dir = $graphite::params::root_dir,
  $gr_user = www-data,
  $gr_group = www-data,
  $storage_aggregation_content = undef,
  $storage_aggregation_source = undef,
  $storage_schemas_content = undef,
  $storage_schemas_source = undef,
  $carbon_source = undef,
  $carbon_content = undef,
  $django_secret_key = undef,
  $django_timezone = 'UTC',
  $smtp_server = undef,
  $use_ldap_auth = 'False',
  $ldap_server = 'ldap.mycompany.com',
  $ldap_port = 389,
  $ldap_search_base = 'OU=users,DC=mycompany,DC=com',
  $ldap_base_user = 'CN=some_readonly_account,DC=mycompany,DC=com',
  $ldap_base_pass = 'readonly_account_password',
  $ldap_user_query = '(username=%s)',
) inherits graphite::params {
  class{'graphite::deps': } ->
  class{'graphite::install': } ->
  class{'graphite::config': } ~>
  class{'graphite::service': } ->
  Class['graphite']
}
