# postgres-replication
[![Build Status](https://travis-ci.org/jmccann/postgres-replication-cookbook.svg?branch=master)](https://travis-ci.org/jmccann/postgres-replication-cookbook)

Use `postgresql` cookbook with additional logic to setup active/passive cluster.

Based on https://cloud.google.com/solutions/setup-postgres-hot-standby

## Supported Platforms

Tested And Validated On
- Ubuntu 15.10
- Ubuntu 16.04

## Usage

TODO: Include usage patterns of any providers or recipes.

### postgres-replication::default

Include `postgres-replication` in your run_list.

```json
{
  "run_list": [
    "recipe[postgres-replication::default]"
  ]
}
```

## Testing

* Linting - Cookstyle and Foodcritic
* Spec - ChefSpec
* Integration - Test Kitchen

Testing requires [ChefDK](https://downloads.chef.io/chef-dk/) be installed using it's native gems.

```
foodcritic -f any -t ~FC016 -X spec .
cookstyle
rspec --color --format progress
```

If you run into issues testing please first remove any additional gems you may
have installed into your ChefDK environment.  Extra gems can be found and removed
at `~/.chefdk/gem`.

## License and Authors

Author:: Jacob McCann (<jacob.mccann2@target.com>)

```text
Copyright:: 2016, Jacob McCann

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
