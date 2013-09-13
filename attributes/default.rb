default[:solr][:port] = '8893'
default[:solr][:home] = '/opt/solr/'
default[:solr][:data_dir] = '' # use the default data directory in solr_home
default[:solr][:core_name] = 'core1' # default core name
default[:solr][:use_shared_data_dir] = false;
default[:solr][:shared_data_dir_name] = 'solr';