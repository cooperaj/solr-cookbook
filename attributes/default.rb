default[:solr][:port] = '8090'
default[:solr][:home] = '/opt/solr/'
default[:solr][:data_dir] = '' # use the default data directory in solr_home
default[:solr][:core_name] = 'core1' # default core name
default[:solr][:solr_version] = '4.3.1'
default[:solr][:log_level] = 'WARN'

default[:solr][:use_shared_data_dir] = false;
default[:solr][:shared_data_dir_name] = 'solr';
