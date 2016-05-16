if defined?(ChefSpec)
  ChefSpec.define_matcher :postgresql_user
  ChefSpec.define_matcher :postgresql_backup

  def create_postgresql_user(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:postgresql_user, :create, resource_name)
  end

  def run_postgresql_backup(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:postgresql_backup, :run, resource_name)
  end
end
