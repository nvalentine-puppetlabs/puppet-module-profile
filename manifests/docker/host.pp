class profile::docker::host(
  $users = [],
  $runs = $::profile::docker::params::default_runs,
  $images = $::profile::docker::params::default_images
) inherits ::profile::docker::params {

  

  validate_array($users)
  validate_hash($images, $runs)
  
  include ::docker

  $images_defaults = { 'ensure' => 'latest' }
  create_resources('::docker::image', $images, $images_defaults)

  $runs_defaults = {}
  create_resources('::docker::run', $runs, $runs_defaults)
}
