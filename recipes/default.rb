#
# Cookbook Name:: solr
# Recipe:: default
#
# Copyright 2012, Example Com
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#     http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe "tomcat-solr::service"

case node[:platform]
when "debian", "ubuntu"

    tomcat_group = "tomcat"

    package "tomcat7" do
        action :install
    end

    # create user tomcat
    user "tomcat" do
        action :create
    end

    # configuring tomcat
    template "/var/lib/tomcat7/conf/Catalina/localhost/solr.xml" do
        source "tomcat_solr.xml.erb"
        owner "root"
        group tomcat_group
        mode "0664"
    end

    # creating solr home and solr core
    directory "#{node[:solr][:home]}" do
        owner "root"
        group tomcat_group
        mode "0777"
        action :create
    end

    if node['solr']['use_shared_data_dir'] then
        execute "mount_solr_data_dir" do
            command "mount -t vboxsf -o uid=`id -u tomcat7` -o gid=`id -g tomcat7` #{node['solr']['shared_data_dir_name']} #{node['solr']['home']}"
            not_if "mount | grep '#{node['solr']['shared_data_dir_name']}' | grep -q \"uid=`id -u tomcat7`\""
            action :run
        end
    end

    # creating solr home and solr core
    directory "#{node[:solr][:home]}/#{node[:solr][:core_name]}" do
        owner "root"
        group tomcat_group
        mode "0777"
        action :create
    end

    directory "#{node[:solr][:home]}/#{node[:solr][:core_name]}/conf" do
        owner "root"
        group tomcat_group
        mode "0777"
        action :create
    end

    directory "#{node[:solr][:home]}/#{node[:solr][:core_name]}/data" do
        owner "root"
        group tomcat_group
        mode "0777"
        action :create
    end

    # configuring solr
    template "#{node[:solr][:home]}/solr.xml" do
        source "solr.xml.erb"
        owner "root"
        group "root"
        mode "0664" 
    end

    template "#{node[:solr][:home]}/#{node[:solr][:core_name]}/conf/solrconfig.xml" do
        source "solrconfig.xml.erb"
        owner "root"
        group "root"
        mode "0644"
    end

    template "#{node[:solr][:home]}/#{node[:solr][:core_name]}/conf/schema.xml" do
        source "schema.xml.erb"
        owner "root"
        group "root"
        mode "0644"
    end

    template "/etc/tomcat7/server.xml" do
        source "server.xml.erb"
        owner "root"
        group "root"
        mode "0644"
    end

    template "#{node[:solr][:home]}/#{node[:solr][:core_name]}/data/elevate.xml" do
        source "elevate.xml.erb"
        owner "root"
        group "root"
        mode "0644"
    end

    #download solr
    remote_file "/tmp/solr.tgz" do
      source "http://archive.apache.org/dist/lucene/solr/#{node[:solr][:solr_version]}/solr-#{node[:solr][:solr_version]}.tgz"
      mode 00644
    end

    #unpack solr package
    bash 'Unpack solr and copy needed libs' do
      cwd '/tmp'
      code <<-EOF
        tar -xzf solr.tgz
        cp solr-#{node[:solr][:solr_version]}/dist/solr-#{node[:solr][:solr_version]}.war /var/lib/tomcat7/webapps/solr.war
        cp solr-#{node[:solr][:solr_version]}/example/lib/ext/* /usr/share/tomcat7/lib/
        cp solr-#{node[:solr][:solr_version]}/example/resources/* /usr/share/tomcat7/lib/
        EOF
      not_if { ::File.exists?('/var/lib/tomcat7/webapps/solr.war') }
    end

    #cleaning
    bash 'Clean solr files' do
      cwd '/tmp'
      code <<-EOF
        rm solr.tgz
        rm -rf solr-#{node[:solr][:solr_version]}
        EOF
      notifies :restart, resources(:service => "tomcat7")
    end

    #configure solr logging
    directory "/var/lib/tomcat7/webapps/solr/WEB-INF/classes" do
      owner "root"
      group "root"
      mode "0644"
      action :create
      notifies :restart, resources(:service => "tomcat7")
    end

    template "/var/lib/tomcat7/webapps/solr/WEB-INF/classes/log4j.properties" do
        source "log4j.properties.erb"
        owner "root"
        group "root"
        mode "0644"
        notifies :restart, resources(:service => "tomcat7")
    end

    template "/var/lib/tomcat7/webapps/solr/WEB-INF/classes/logging.properties" do
        source "logging.properties.erb"
        owner "root"
        group "root"
        mode "0644"
        notifies :restart, resources(:service => "tomcat7")
    end

end
