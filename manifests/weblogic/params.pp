class profile::weblogic::params {
 
  unless 'redhat' == $::osfamily {
    fail("This profile currently supports only ::osfamily 'redhat'!")
  }

  $default_staging_dir = "/opt/staging/${module_name}"
  
  $default_oracle_home = '/opt/oracle'
  
  $default_java_version = '8'
  $default_java_home = "${default_oracle_home}/java"

  $default_weblogic_version = '1212'
  $default_middleware_home = "${default_oracle_home}/middleware/weblogic/${default_weblogic_version}"
  $default_weblogic_home = "${default_middleware_home}/wlserver"
  
  $default_wls_user = 'weblogic'
  $default_wls_group = 'weblogic'
  $default_wls_password = 'weblogic123'

  $enable_gui_admin = true

  $default_default_domain_password = 'weblogic123'
}

