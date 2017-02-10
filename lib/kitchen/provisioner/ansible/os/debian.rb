# -*- encoding: utf-8 -*-
#
# Author:: Michael Heap (<m@michaelheap.com>)
#
# Copyright (C) 2015 Michael Heap
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

module Kitchen
  module Provisioner
    module Ansible
      class Os
        class Debian < Os
          def update_packages_command
            @config[:update_package_repos] ? "#{sudo_env('apt-get')} update" : nil
          end

          def ansible_debian_version
            if @config[:ansible_version] == 'latest' || @config[:ansible_version] == nil
              ''
            else
              "=#{@config[:ansible_version]}"
            end
          end

          def install_command
            <<-INSTALL

            if [ ! $(which ansible) ]; then
              #{update_packages_command}

              ## Install apt-utils to silence debconf warning: http://serverfault.com/q/358943/77156
              #{sudo_env('apt-get')} -y install apt-utils git

              ## Fix debconf tty warning messages
              export DEBIAN_FRONTEND=noninteractive

              ## 13.10, 14.04 include add-apt-repository in software-properties-common
              #{sudo_env('apt-get')} -y install software-properties-common

              ## 10.04, 12.04 include add-apt-repository in
              #{sudo_env('apt-get')} -y install python-software-properties

              ## AJE
              #{sudo_env('apt-get')} -y install git
              git clone git@github.com:aerickson/ansible.git /tmp/ansible_git_install

            fi
            INSTALL
          end
        end
      end
    end
  end
end
