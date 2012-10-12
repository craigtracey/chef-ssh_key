# Copyright 2012, Craig Tracey <craigtracey@gmai.com>
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

private
def hash_in_authorized_file(file, hash)
  found = false
  linenum = 0

  if ::File.exists?(file)
    ::File.open(file, "r") do |file|
      file.readlines.each do |line|
        if line.index(hash)
          found = true
          break
        end
        linenum += 1
      end
    end
  end

  if found
    linenum
  else
    return -1
  end
end

private
def delete_line_from_file(file, linenum)
  lines = ::File.readlines(file)
  lines.delete_at(linenum)
  ::File.open(file, "w") do |f|
    f.flock(::File::LOCK_EX)
    lines.each{|line| f.puts(line)}
    f.flush
    f.close
  end
end

private
def get_authorized_file(user)
  if (user == "root")
    home_dir = "/root"
  else
    home_dir = "/home/#{user}"
  end

  if not ::File.exists?(home_dir)
    Chef::Log.fatal("User #{user} does not have a home directory")
    raise Chef::Exceptions::ConfigurationError
  end
  file = "#{home_dir}/.ssh/authorized_keys"
end

private
def get_hash(key)
  key_parts = key.split(/\s+/)
  if key_parts.length == 1
    return key
  elsif key_parts.length > 1
    return key_parts[1]
  end
end

action :remove do

  if not new_resource.authorized_file
    file = get_authorized_file(new_resource.user)
  else
    file = new_resource.authorized_file
  end

  new_resource.keys.each do |key|
    hash = get_hash(key)
    line = hash_in_authorized_file(file, hash)
    if line != -1
      Chef::Log.info("Removing key #{hash[0..10]} for #{new_resource.user}")
      delete_line_from_file(file, line)
    end
  end
end

action :add do

  if not new_resource.authorized_file
    file = get_authorized_file(new_resource.user)
  else
    file = new_resource.authorized_file
  end

  new_resource.keys.each do |key|
    hash = get_hash(key)
    line = hash_in_authorized_file(file, hash)
    if (line == -1)
      Chef::Log.info("Adding key #{hash[0..10]} for #{new_resource.user}")
      ::File.open(file, "a") do |f|
        f.flock(::File::LOCK_EX)
        f.write("#{key}\n")
        f.flush
        f.close
      end
    end
  end
end
