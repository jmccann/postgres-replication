# Make sure we are not saving the password to node attributes
describe file('/tmp/kitchen/nodes/master-ubuntu-1510.json') do
  it { should exist }
  its('content') { should_not include 'anMzQk5GcXtAOENkTFV2Cg==' }
end
