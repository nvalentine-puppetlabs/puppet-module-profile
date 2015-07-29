class profile::weblogic::params {
 
  unless 'redhat' == $::osfamily {
    fail("This profile currently supports only ::osfamily 'redhat'!")
  }

  $staging_dir = '/opt/staging/profile'

  $default_wls_user = 'weblogic'
  $default_wls_group = 'weblogic'
}

