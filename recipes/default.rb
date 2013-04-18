#
# Cookbook Name:: libmemcached
# Recipe:: default
#
# Copyright 2012, Go Try It On, Inc.
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

include_recipe "build-essential"

package "libcloog-ppl0" do
  action :install
end

package "libevent-dev" do
  action :install
end

version = node[:libmemcached][:version]

remote_file "#{Chef::Config[:file_cache_path]}/libmemcached-#{version}.tar.gz" do
  source "https://launchpad.net/libmemcached/1.0/#{version}/+download/libmemcached-#{version}.tar.gz"
  checksum node[:libmemcached][:checksum]
  mode "0644"
  not_if { File.directory?("/usr/local/include/libmemcached-1.0") }
end

bash "build libmemcached" do
  cwd Chef::Config[:file_cache_path]
  code <<-EOF
    gzip -d libmemcached-#{version}.tar.gz
    tar -xvf libmemcached-#{version}.tar
    (cd libmemcached-#{version} && ./configure)
    (cd libmemcached-#{version} && make && make install)
  EOF
  not_if { File.directory?("/usr/local/include/libmemcached-1.0") }
end
