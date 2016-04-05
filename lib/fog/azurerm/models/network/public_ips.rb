require 'fog/core/collection'
require 'fog/azurerm/models/network/public_ip'

module Fog
  module Network
    class AzureRM
      class PublicIps < Fog::Collection
        model Fog::Network::AzureRM::PublicIp
        attribute :resource_group

        def all
          requires :resource_group
          public_ips = []
          pubip_list = service.list_public_ips(resource_group)
          pubip_list.each do |pip|
            hash = {}
            pip.instance_variables.each do |var|
              hash[var.to_s.delete('@')] = pip.instance_variable_get(var)
            end
            hash['resource_group'] = resource_group
            public_ips << hash
          end
          load(public_ips)
        end

        def get(identity)
          all.find { |f| f.name == identity }
        rescue Fog::Errors::NotFound
          nil
        end

        def check_if_exists(resource_group, name)
          puts "Checkng if PublicIP #{name} exists."
          if service.check_for_public_ip(resource_group, name) == true
            puts "PublicIP #{name} exists."
          else
            puts "PublicIP #{name} doesn't exists."
          end
        end
      end
    end
  end
end