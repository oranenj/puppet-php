# Configure a yum repo for RedHat-based systems
#
# === Parameters
#
# [*yum_repo*]
#   Class name of the repo under ::yum::repo
#

class php::repo::redhat (
  $yum_repo = 'remi_php56',
) {


  if $php::globals::use_scl {
    if $facts['os']['name'] == 'CentOS' {
      ensure_packages(['centos-release-scl'])
    } else {
      fail("Managing SCL repositories is only supported on CentOS")
    }
  } else {
    $releasever = $facts['os']['name'] ? {
      /(?i:Amazon)/ => '6',
      default       => '$releasever',  # Yum var
    }

    yumrepo { 'remi':
      descr      => 'Remi\'s RPM repository for Enterprise Linux $releasever - $basearch',
      mirrorlist => "https://rpms.remirepo.net/enterprise/${releasever}/remi/mirror",
      enabled    => 1,
      gpgcheck   => 1,
      gpgkey     => 'https://rpms.remirepo.net/RPM-GPG-KEY-remi',
      priority   => 1,
    }

    yumrepo { 'remi-php56':
      descr      => 'Remi\'s PHP 5.6 RPM repository for Enterprise Linux $releasever - $basearch',
      mirrorlist => "https://rpms.remirepo.net/enterprise/${releasever}/php56/mirror",
      enabled    => 1,
      gpgcheck   => 1,
      gpgkey     => 'https://rpms.remirepo.net/RPM-GPG-KEY-remi',
      priority   => 1,
    }
  }
}
