#
# Author:: Seth Chisamore (<schisamo@opscode.com>)
# Copyright:: Copyright (c) 2011 Opscode, Inc.
# License:: Apache License, Version 2.0
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

require 'chef/provider/file'
require 'chef/resource/windows_file'
require 'chef/file_access_control'

class Chef
  class Provider
    class WindowsFile < Chef::Provider::File

      def load_current_resource
        @current_resource = Chef::Resource::WindowsFile.new(@new_resource.name)
        @new_resource.path.gsub!(/\\/, "/") # for Windows
        @current_resource.path(@new_resource.path)

        # TODO set owner, group, rights for @current_resource
        # if ::File.exist?(@current_resource.path) && ::File.readable?(@current_resource.path)
        #   @current_resource.owner()
        #   @current_resource.group()
        #   @current_resource.rights()
        # end

        @current_resource
      end

      def action_create
        super
        enforce_ownership_and_permissions
      end
    end
  end
end
