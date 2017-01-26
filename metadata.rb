name             'postgres-replication'
maintainer       'Jacob McCann'
maintainer_email 'jacob.mccann2@target.com'
license          'Apache 2.0'
description      'Installs/Configures postgres-replication'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
source_url       'https://github.com/jmccann/postgres-replication-cookbook'
issues_url       'https://github.com/jmccann/postgres-replication-cookbook/issues'
version          '1.0.0'

depends 'chef-vault', '~> 1.3'
depends 'postgresql', '~> 6.0'
