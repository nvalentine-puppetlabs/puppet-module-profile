class profile::mesos::master(
  $all_in_one = true
) inherits ::profile::mesos::params {

  require ::profile::mesos

  validate_bool($all_in_one)

  if true == $all_in_one {
    include ::profile::mesos::allinone
  } else {
    fail("Sorry, only all-in-one Mesos master supported at this time!")
  }
  
}
