class profile::vsphere_broker::params {
  unless 'Linux' == $::kernel {
    fail("${::kernel}-based OSes are not supported by this profile!")
  }

  $default_gems = {
    'rbvmomi' => { 'ensure' => '1.8.2', },
    'hocon' => { 'ensure' => 'present' }
  }
}
