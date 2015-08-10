class weblogic::clustermember(

) inherits ::weblogic::params {

  require ::weblogic

  class { '::weblogic::clustermember::config': } ->
  Class['::weblogic::clustermember']
}
