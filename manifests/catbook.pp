stage { "pre": before => Stage["main"] }

class python {
    package {
        "build-essential": ensure => latest;
        "python": ensure => "latest";
        "python-dev": ensure => "latest";
        "python-setuptools": ensure => installed;
    }
    exec { "easy_install pip":
        path => "/usr/local/bin:/usr/bin:/bin",
        refreshonly => true,
        require => Package["python-setuptools"],
        subscribe => Package["python-setuptools"],
    }
}

class django {
    class { "python": stage => "pre" }
    package {
        "django":
            ensure => "1.7.1",
            provider => pip;
    }
}

class server {
    service { "nginx":
        ensure  => "running",
        enable  => "true",
        require => Package["nginx"],
    }
    package {
        "nginx":
            ensure => "latest";
        "uwsgi":
            ensure => "2.0.8",
            provider => pip;
    }
    file { "/etc/nginx/sites-available/default":
        notify  => Service["nginx"],
        mode   => 644,
        owner  => root,
        group  => root,
        source => "/vagrant/catbook/nginx.conf",
        require => Package["nginx"],
    }
}

class catbook {
    class { "django": stage => "pre" }
    class { "server": stage => "pre" } 
    exec { "/vagrant/catbook/run": }
}

class { "catbook": stage => "main" }
