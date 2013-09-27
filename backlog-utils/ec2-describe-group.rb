require 'rubygems'
require 'aws-sdk'

AWS.config(YAML.load(File.read('config.yml')))
ec2_client = AWS::EC2.new.client

result = ec2_client.describe_security_groups()

tmp_array = []

result[:security_group_info].each { |sg_info|
	group_name = sg_info[:group_name]
	group_id   = sg_info[:group_id]
	inbound    = sg_info[:ip_permissions]
	outbound   = sg_info[:ip_permissions_egress]
	tmp_array << [group_name + '(' + group_id + ')',inbound,outbound]
}

tmp_array.each {|tmp|
	puts '** ' + tmp[0]
	puts '*** inbound'
	puts '|ip|protocol|port|h'
	tmp[1].each { |inbound|
		protocol = inbound[:ip_protocol] 
		port = inbound[:from_port].to_s 
		if protocol == '-1' then
			protocol = 'ALL'
			port = 'ALL'
		end
		if protocol == 'icmp' then
			port = '-'
		end
		
		inbound[:ip_ranges].each {|ip_range|
			puts '|' + ip_range[:cidr_ip] + '|' + protocol + '|' + port + '|'
		}

		inbound[:groups].each {|group|
			puts '|' + group[:group_id].to_s + '|' + protocol + '|' + port + '|'
		}
	}

	puts '*** outbound'
	puts '|ip|protocol|port|h'
	tmp[2].each { |outbound|
		protocol = outbound[:ip_protocol] 
		port = outbound[:from_port].to_s 
		if protocol == '-1' then
			protocol = 'ALL'
			port = 'ALL'
		end
		if protocol == 'icmp' then
			port = '-'
		end

		outbound[:ip_ranges].each {|ip_range|
			puts '|' + ip_range[:cidr_ip] + '|' + protocol + '|' + port + '|'
		}

		outbound[:groups].each {|group|
			puts '|' + group[:group_id].to_s + '|' + protocol + '|' + port + '|'
		}
	}
	puts
}
