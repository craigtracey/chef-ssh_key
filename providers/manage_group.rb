# Copyright 2012, Craig Tracey <craigtracey@gmail.com>
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

def initialize(*args)
  super
  @action = :add
end

action :remove do
  search(new_resource.data_bag, "id:#{new_resource.group}") do |u|
    u['users'].each do |username,keys|
      ssh_key_manage username do
        keys keys
        action :remove
      end
    end
  end
end

action :add do
  search(new_resource.data_bag, "id:#{new_resource.group}") do |u|
    u['users'].each do |username,keys|
      ssh_key_manage username do
        keys keys
      end
    end
  end
end
