require 'rubygems'
require 'aws-sdk-v1'

AWS.config(YAML.load(File.read('../config.yml')))
ec2_client = AWS::EC2.new.client

result = ec2_client.describe_route_tables()

tmp_array = []

result[:route_table_set].each { |route_table_set|
  route_table_id    = route_table_set[:route_table_id ]
  route_set    = route_table_set[:route_set]
  tmp_array << ['' + route_table_id  + '',route_set]
}

tmp_array.each {|tmp|
  puts '** ' + tmp[0]
  puts '|destination_cidr_block|gateway_id|h'
  tmp[1].each { |route_set|
    destination_cidr_block = route_set[:destination_cidr_block]
    gateway_id = route_set[:gateway_id]
    gateway_id = route_set[:gateway_id]
    puts '|' + destination_cidr_block + '|' + gateway_id + '|'
  }
  puts
}
