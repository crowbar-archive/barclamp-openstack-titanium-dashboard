# Copyright 2011, Dell, Inc. 
# 
# Licensed under the Apache License, Version 2.0 (the "License"); 
# you may not use this file except in compliance with the License. 
# You may obtain a copy of the License at 
# 
#  http://www.apache.org/licenses/LICENSE-2.0 
# 
# Unless required by applicable law or agreed to in writing, software 
# distributed under the License is distributed on an "AS IS" BASIS, 
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. 
# See the License for the specific language governing permissions and 
# limitations under the License. 
# 

class NovaDashboardService < ServiceObject

  def initialize(thelogger)
    @bc_name = "nova_dashboard"
    @logger = thelogger
  end

# Turn off multi proposal support till it really works and people ask for it.
  def self.allow_multiple_proposals?
    false
  end

  def proposal_dependencies(role)
    answer = []
    answer << { "barclamp" => "haproxy", "inst" => role.default_attributes[@bc_name]["haproxy_instance"] }
    answer << { "barclamp" => "percona", "inst" => role.default_attributes[@bc_name]["percona_instance"] }
    answer << { "barclamp" => "keystone", "inst" => role.default_attributes[@bc_name]["keystone_instance"] }
    answer << { "barclamp" => "nova", "inst" => role.default_attributes[@bc_name]["nova_instance"] }
    answer
  end
  
  def create_proposal
    @logger.debug("Nova_dashboard create_proposal: entering")
    base = super

    # HAProxy dependency
    base["attributes"][@bc_name]["haproxy_instance"] = ""
    begin
      haproxyService = HaproxyService.new(@logger)
      haproxys = haproxyService.list_active[1]
      if haproxys.empty?
        # No actives, look for proposals
        haproxys = haproxyService.proposals[1]
      end
      base["attributes"][@bc_name]["haproxy_instance"] = haproxys[0] unless haproxys.empty?
    rescue
      @logger.info("Nova_dashboard create_proposal: no haproxy found")
    end
    if base["attributes"][@bc_name]["haproxy_instance"] == ""
      raise(I18n.t('model.service.dependency_missing', :name => @bc_name, :dependson => "haproxy"))
    end

    # Percona dependency
    base["attributes"][@bc_name]["percona_instance"] = ""
    begin
      perconaService = PerconaService.new(@logger)
      perconas = perconaService.list_active[1]
      if perconas.empty?
        # No actives, look for proposals
        perconas = perconaService.proposals[1]
      end
      base["attributes"][@bc_name]["percona_instance"] = perconas[0] unless perconas.empty?
    rescue
      @logger.info("Nova_dashboard create_proposal: no percona found")
    end
    if base["attributes"][@bc_name]["percona_instance"] == ""
      raise(I18n.t('model.service.dependency_missing', :name => @bc_name, :dependson => "percona"))
    end

    # Keystone dependency
    base["attributes"][@bc_name]["keystone_instance"] = ""
    begin
      keystoneService = KeystoneService.new(@logger)
      keystones = keystoneService.list_active[1]
      if keystones.empty?
        # No actives, look for proposals
        keystones = keystoneService.proposals[1]
      end
      base["attributes"][@bc_name]["keystone_instance"] = keystones[0] unless keystones.empty?
    rescue
      @logger.info("Nova_dashboard create_proposal: no keystone found")
    end
    if base["attributes"][@bc_name]["keystone_instance"] == ""
      raise(I18n.t('model.service.dependency_missing', :name => @bc_name, :dependson => "keystone"))
    end

    # Nova dependency
    base["attributes"][@bc_name]["nova_instance"] = ""
    begin
      novaService = NovaService.new(@logger)
      novas = novaService.list_active[1]
      if novas.empty?
        # No actives, look for proposals
        novas = novaService.proposals[1]
      end
      base["attributes"][@bc_name]["nova_instance"] = novas[0] unless novas.empty?
    rescue
      @logger.info("Nova dashboard create_proposal: no nova found")
    end
    if base["attributes"][@bc_name]["nova_instance"] == ""
      raise(I18n.t('model.service.dependency_missing', :name => @bc_name, :dependson => "nova"))
    end

#    nodes = NodeObject.all
#    nodes.delete_if { |n| n.nil? or n.admin? }
#    if nodes.size >= 1
#      base["deployment"]["nova_dashboard"]["elements"] = {
#        "nova_dashboard-server" => [ nodes.first[:fqdn] ]
#      }
#    end

    #Common Password for all nodes - instead of in server.rb
    base["attributes"]["nova_dashboard"]["db"]["password"] = random_password

    @logger.debug("Nova_dashboard create_proposal: exiting")
    base
  end

  def apply_role_pre_chef_call(old_role, role, all_nodes)
    @logger.debug("Nova_dashboard apply_role_pre_chef_call: entering #{all_nodes.inspect}")
    return if all_nodes.empty?

    # Make sure the nodes have a link to the dashboard on them.
    all_nodes.each do |n|
      node = NodeObject.find_node_by_name(n)
      server_ip = node.get_network_by_type("admin")["address"]
      node.crowbar["crowbar"] = {} if node.crowbar["crowbar"].nil?
      node.crowbar["crowbar"]["links"] = {} if node.crowbar["crowbar"]["links"].nil?
      node.crowbar["crowbar"]["links"]["Nova Dashboard"] = "http://#{server_ip}/"
      node.save
    end
    @logger.debug("Nova_dashboard apply_role_pre_chef_call: leaving")
  end

end

