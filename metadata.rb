name             'postgres-replication'
maintainer       'Jacob McCann'
maintainer_email 'jacob.mccann2@target.com'
license          'all_rights'
description      'Installs/Configures tgt-ha-postgres'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
source_url       'https://github.com/jmccann/ha-postgres-cookbook'
issues_url       'https://github.com/jmccann/ha-postgres-cookbook/issues'
version          '0.1.0'

depends 'chef-vault', '~> 1.3'
depends 'postgresql', '~> 4.0'
