#
# Cookbook Name:: laravel
# Recipe:: database
#
# Copyright 2014, Michael Beattie
#
# Licensed under the MIT License.
# You may obtain a copy of the License at
#
#     http://opensource.org/licenses/MIT
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Laravel Database Node
db = node['laravel']['db']

::Chef::Recipe.send(:include, Laravel::Helpers)
path = project_path

case node['laravel']['database_driver']
when 'mysql'
  include_recipe "mysql::client"
  # Check if this is a development machine
  if is_local_host? db['host']
    include_recipe "mysql::server"
  end

  include_recipe "database::mysql"

  db_connection_info = {
      :host     => db['host'],
      :username => 'root',
      :password => node['mysql']['server_root_password']
    }
  db_provider = Chef::Provider::Database::Mysql
when 'pgsql'
  include_recipe "postgresql::client"
  # Check if this is a development machine
  if is_local_host? db['host']
    include_recipe "postgresql::server"
  end

  include_recipe "database::postgresql"

  db_connection_info = {
      :host     => db['host'],
      :port     => node['postgresql']['config']['port'],
      :username => 'postgres',
      :password => node['postgresql']['password']['postgres']
    }
  db_provider = Chef::Provider::Database::Postgresql
end

# Create the database if it does not already exist
database db['name'] do
  connection db_connection_info
  provider db_provider
  action :create
end

# Control the database config file via Chef so that
# settings can be configured per-environment (e.g.: dev, staging, prod)
template "#{path}/app/config/database.php" do
  mode "0644"
end

# Create the migration table in the database
# Note: This seems to be already idempotent, 
#       but if a check exists, we should use the appropriate not_if shell guard
execute "Run Initial Migration" do
  action :run
  command "cd #{path}; php artisan migrate"
end
