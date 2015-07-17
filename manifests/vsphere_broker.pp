class profile::vsphere_broker(
  $vcenter_server,
  $vcenter_user,
  $vcenter_password,
  $addtl_gems = {},
) inherits ::profile::vsphere_broker::params {

  multi_validate_re($vcenter_server, $vcenter_user, $vcenter_password, '^.+$')
  validate_hash($addtl_gems)

  $gems = merge($addtl_gems, $default_gems)
  validate_hash($gems)

  $gems_defaults = { 'ensure' => 'present', 'provider' => 'pe_gem', }
  create_resources('package', $gems, $gems_defaults)

  file { 'vCenter config file':
    ensure => file,
    path => "/etc/puppetlabs/puppet/vcenter.conf",
    mode => '0700',
    owner => 'root',
    group => 'root',
    content => template("${module_name}/profile/vsphere_broker/vcenter.conf.erb"),
  }
}
