#
# This script lists up snapshots has no EBS volumes.
#
require 'rubygems'
require 'aws-sdk'

OWNER_ID = 'YOUR_OWNER_ID' # omit hyphen
ACCESS_KEY_ID = 'YOUR_ACCESS_KEY_ID'
SECRET_ACCESS_KEY = 'YOUR_SECRET_ACCESS_KEY'
REGION = 'ap-northeast-1'

AWS.config(
  :access_key_id => ACCESS_KEY_ID,
  :secret_access_key => SECRET_ACCESS_KEY,
  :region => REGION

)
ec2_client = AWS::EC2.new.client

# describe all my snapshots
snapshots = []
snapshot_set = ec2_client.describe_snapshots(:owner_ids => [OWNER_ID])[:snapshot_set]
snapshot_set.each { |snapshot|
  snapshots << [snapshot[:snapshot_id] , snapshot[:volume_id]]
}

# describe all my volumes
volume_set = ec2_client.describe_volumes()[:volume_set]
volumes = []
volume_set.each {|volume|
  volumes << [volume[:snapshot_id] , volume[:volume_id]]
}

# check alone snapshots
snapshots.each { |snapshot|
  snapshot_id = snapshot[0]
  snapshot_volume_id = snapshot[1]
  is_alone = true
  volumes.each { |volume|
    volume_snapshot_id = volume[0]
    volume_id = volume[1]
    if volume_id != nil &&  snapshot_volume_id  == volume_id then
      is_alone = false
      break
    end
  }
  if is_alone then
    # out put anlone snapshot_id
    puts snapshot_id
  end
}

exit
