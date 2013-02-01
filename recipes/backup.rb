#
# Cookbook Name:: alfresco
# Recipe:: backup
#

db_database     = node['alfresco']['db']['database']
db_user         = node['alfresco']['db']['user']
db_pass         = node['alfresco']['db']['password']
backup_dest_dir = node['alfresco']['backup']['dest_dir']
root_dir        = node['alfresco']['root_dir']

backup_name     = "alfresco_backup_#{DateTime.now.strftime("%Y%m%dT%H%M%S%z")}"

service "tomcat7" do
  action :stop
end

ruby_block "wait" do
  block do
    sleep(10)
  end
  action :create
end

directory "/tmp/#{backup_name}" do
  :create
end

execute "dump_database" do
  command "mysqldump -u #{db_user} --password=#{db_pass} #{db_database} > /tmp/#{backup_name}/database.sql"
end

execute "copy_files" do
  command "cp -R #{root_dir} /tmp/#{backup_name}"
end

execute "compress" do
  cwd "/tmp"
  command "tar zcf #{backup_name}.tar.gz #{backup_name}"
end

directory backup_dest_dir do
  owner "root"
  group "root"
  mode 00700
  :create
end

execute "move" do
  cwd "/tmp"
  command "mv #{backup_name}.tar.gz #{backup_dest_dir}"
end

execute "remove_tmp" do
  cwd "/tmp"
  command "rm -Rf /tmp/#{backup_name}"
end

execute "start-tomcat7" do
  command "/etc/init.d/tomcat7 start"
end


