#
# Cookbook Name:: alfresco
# Recipe:: file_server
#
# Copyright 2013, Pritesh Mehta
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

### Setup Variables

root_dir = node['alfresco']['root_dir']

if node['alfresco']['file_server']['enabled']
  ## Setup FS share if enabled on this box
  case node['platform']
  when "windows"
    # windows share recipe here
  else
    ## extract nfs into its own recipe and use the following to load it/specified recipe
    # include_recipe "_file_server_#{node['alfresco']['file_server']['export']['type']}"
    #
    include_recipe "nfs::server"
    nfs_export node['alfresco']['file_server']['export']['root'] do
      network node['alfresco']['file_server']['export']['nfs']['network']
      writeable true
      sync true
    end
  end
end
