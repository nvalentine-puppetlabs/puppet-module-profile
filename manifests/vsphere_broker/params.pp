class profile::vsphere_broker::params {
  unless 'Linux' == $::kernel {
    fail("${::kernel}-based OSes are not supported by this profile!")
  }

  $default_gems = {
    'rbvmomi' => { 'ensure' => 'present' },
    'hocon' => { 'ensure' => 'present' }
  }
}
