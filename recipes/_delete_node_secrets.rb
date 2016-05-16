ruby_block "delete all attributes in node['postgresql']['password']" do
  block do
    node.rm(:postgresql, :password)
  end
end
