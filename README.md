# postgres-replication

Use `postgresql` cookbook with additional logic to setup active/passive cluster.

Based on https://cloud.google.com/solutions/setup-postgres-hot-standby

## Supported Platforms

Tested And Validated On
- Ubuntu 15.10

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

* Linting - Rubocop and Foodcritic
* Spec - ChefSpec
* Integration - Test Kitchen

Testing requires [ChefDK](https://downloads.chef.io/chef-dk/) be installed using it's native gems.

```
foodcritic -f any -X spec .
rubocop
rspec --color --format progress
```

If you run into issues testing please first remove any additional gems you may
have installed into your ChefDK environment.  Extra gems can be found and removed
at `~/.chefdk/gem`.

## License and Authors

Author:: Jacob McCann (<jacob.mccann2@target.com>)

```text
Copyright (c) 2016 Jacob McCann, All Rights Reserved.
```
