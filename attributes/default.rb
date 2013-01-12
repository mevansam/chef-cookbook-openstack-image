#
# Cookbook Name:: glance
# Attributes:: default
#
# Copyright 2012, Rackspace US, Inc.
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

# Set to some text value if you want templated config files
# to contain a custom banner at the top of the written file
default["glance"]["custom_template_banner"] = "
# This file autogenerated by Chef
# Do not edit, changes will be overwritten
"

default["glance"]["verbose"] = "False"
default["glance"]["debug"] = "False"
# This is the name of the Chef role that will install the Keystone Service API
default["glance"]["keystone_service_chef_role"] = "keystone"

default["glance"]["user"] = "glance"
default["glance"]["group"] = "glance"

# Gets set in the Image Endpoint when registering with Keystone
default["glance"]["region"] = "RegionOne"

# The name of the Chef role that knows about the message queue server
# that Glance uses
default["glance"]["rabbit_server_chef_role"] = "rabbitmq-server"

default["glance"]["db"]["username"] = "glance" # node_attribute

default["glance"]["service_tenant_name"] = "service"                        # node_attribute
default["glance"]["service_user"] = "glance"                                # node_attribute
default["glance"]["service_role"] = "admin"                                 # node_attribute

# Keystone PKI signing directory. Only written to the filter:authtoken section
# of the api-paste.ini when node["openstack"]["auth"]["strategy"] == "pki"
default["glance"]["api"]["auth"]["cache_dir"] = "/var/cache/glance/api"
default["glance"]["registry"]["auth"]["cache_dir"] = "/var/cache/glance/registry"

default["glance"]["api"]["default_store"] = "file"                          # node_attribute
default["glance"]["api"]["swift"]["container"] = "glance"             # node_attribute
default["glance"]["api"]["swift"]["large_object_size"] = "200"        # node_attribute
default["glance"]["api"]["swift"]["large_object_chunk_size"] = "200"  # node_attribute
default["glance"]["api"]["cache"]["image_cache_max_size"] = "10737418240"   # node_attribute

# Default Image Locations
default["glance"]["image_upload"] = false                                                                                           # node_attribute
default["glance"]["images"] = [ "cirros" ]                                                                                          # node_attribute
default["glance"]["image"]["precise"] = "http://cloud-images.ubuntu.com/precise/current/precise-server-cloudimg-amd64-disk1.img"    # node_attribute
default["glance"]["image"]["oneiric"] = "http://cloud-images.ubuntu.com/oneiric/current/oneiric-server-cloudimg-amd64-disk1.img"    # node_attribute
default["glance"]["image"]["natty"] = "http://cloud-images.ubuntu.com/natty/current/natty-server-cloudimg-amd64-disk1.img"          # node_attribute
default["glance"]["image"]["cirros"] = "https://launchpadlibrarian.net/83305348/cirros-0.3.0-x86_64-disk.img"                       # node_attribute

# logging attribute
default["glance"]["syslog"]["use"] = false                  # node_attribute
default["glance"]["syslog"]["facility"] = "LOG_LOCAL2"      # node_attribute
default["glance"]["syslog"]["config_facility"] = "local2"   # node_attribute

# platform-specific settings
case platform
when "fedora", "redhat", "centos" # :pragma-foodcritic: ~FC024 - won't fix this
  default["glance"]["platform"] = {
    "mysql_python_packages" => [ "MySQL-python" ],                  # node_attribute
    "glance_packages" => [ "openstack-glance", "openstack-swift", "cronie" ], # node_attribute
    "glance_api_service" => "openstack-glance-api",                 # node_attribute
    "glance_registry_service" => "openstack-glance-registry",       # node_attribute
    "glance_api_process_name" => "glance-api",                      # node_attribute
    "package_overrides" => ""                                       # node_attribute
  }
when "ubuntu"
  default["glance"]["platform"] = {
    "mysql_python_packages" => [ "python-mysqldb" ],                # node_attribute
    "glance_packages" => [ "glance", "python-swift" ],              # node_attribute
    "glance_api_service" => "glance-api",                           # node_attribute
    "glance_registry_service" => "glance-registry",                 # node_attribute
    "glance_registry_process_name" => "glance-registry",            # node_attribute
    "package_overrides" => "-o Dpkg::Options::='--force-confold' -o Dpkg::Options::='--force-confdef'" # node_attribute
  }
end
