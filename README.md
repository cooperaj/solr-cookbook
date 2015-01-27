Description
===========
Downloads ,configures and deploys Solr on Tomcat 7.

Requirements
============

Platform:

Debian, Ubuntu (OpenJDK, Oracle)

Attributes
==========

node['solr']['port'] - The port used by Solr server (Tomcat 7 HTTP connector). Default: 8090.    
node['solr']['home'] - Directory that will hold Solr configuration and data storage. Default: /opt/solr     
node['solr']['data_dir'] - Directory to hold indexes data. Default: solr_home/data.     
node['solr']['core_name'] - Name of the running Solr core
node['solr']['solr_version'] - Version of solr which will be downloaded, installed and deployed on vagrant machine
node['solr']['use_shared_data_dir'] = Use a shared folder in vagrant for your data
node['solr']['shared_data_dir_name'] = The name of hte shared folder

Usage
=====

Simply include the recipe where you want Solr server running.
