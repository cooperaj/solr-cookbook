name             "tomcat-solr"
maintainer       "Adam Cooper"
maintainer_email "adam@networkpie.co.uk"
license          "BSD"
description      "Installs/Configures solr"
version          "0.1.2"

recipe "solr", "Install and setup a solr instance"

depends "apt", ">= 0.0.0"
depends "java", ">= 0.0.0"

%w{ ubuntu debian }.each do |os|
  supports os
end