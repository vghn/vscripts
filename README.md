# VScripts
  [![Build Status](https://travis-ci.org/vghn/vscripts.svg?branch=master)](https://travis-ci.org/vghn/vscripts)
  [![Code Climate](https://codeclimate.com/github/vghn/vscripts.png)](https://codeclimate.com/github/vghn/vscripts)
  [![Gem Version](https://badge.fury.io/rb/vscripts.svg)](http://badge.fury.io/rb/vscripts)
  [![Coverage Status](https://coveralls.io/repos/vghn/vscripts/badge.png)](https://coveralls.io/r/vghn/vscripts)
  [![Dependency Status](https://gemnasium.com/vghn/vscripts.svg)](https://gemnasium.com/vghn/vscripts)

Automation daemon.

## Dependencies
- Ruby >= 1.9.3
- An AWS account (you'll need to create)

## Installing

### Gem installation
`gem install vscripts`


## Usage

```
vscripts GLOBAL-OPTIONS COMMAND OPTIONS
```


### Global Options
```
-h|--help: Displays VScripts help.
-v|--version: Displays the version number.
```


### Commands

1. **Tags2Facts**
  This command can only be run on an AWS EC2 instance. It looks for all tags
associated with it and dumps them in a JSON file. By default this file is
`/etc/facter/facts.d/ec2_tags.json`. It can be overridden with the
***`--file`*** argument.
The `Name` and `Domain` tags are excluded by default because this command is
intended to add Facter facts and these 2 already exist in Facter. This behaviour
can be overridden by adding `[-a|--all]` command line option.

    **Options**:

    ```
    --file, -f <s>: The file that will store the tags (default:
                    /etc/facter/facts.d/ec2_tags.json)
    --all,  -a: Collect all tags
    --help, -h: Shows help
    ```

    **Examples**:

    ```
    $ vscripts tags2facts
    $ vscripts tags2facts --file /tmp/my_tags.json --all
    ```

2. **Identify**
  This command creates a themed host name and fully qualified domain name for
the server, using AWS EC2 tags. The default theme is `Group-Role-#` which means
that the command collects the value of the `Group` and the `Role` AWS EC2 tags
(if they are associated with the instance). Additionally, the value of the
`Domain` tag is also collected so the resulting new host name will be
`MYGROUP-MYROLE-#.MYDOMAIN`.
These tags can be any existing EC2 tags. `#` is used as a placeholder for a
number. This number starts at 1, and, in case other similarly named instances
exist in the current AWS account, it will be incremented accordingly.
Once a new host name is composed, both `/etc/hostname` and `/etc/hosts` are
modified on the local instance and a new `Name` EC2 tag is created and
associated with the current instance.

    If a ***--host*** argument is provided it will override the default theme.
    *DOMAIN* is still looked up.

    If a ***--domain*** argument is provided it will override the default
    domain.

    **Options**:

    ```
    --ec2-tag-theme, -e <s>: Theme (default: Group-Role-#)
    --host, -n <s>: Host name
    --domain, -d <s>: Domain
    --help, -h: Shows help
    ```

    **Examples**:

    ```
    $ vscripts identify
    MyGroup-MyRole-1.Example.tld
    $ vscripts identify --ec2-tag-theme NAME-#
    MyName-1.Example.tld
    $ vscripts identify --host myhost --domain example.com
    myhost.example.com
    ```


## Contributing

1. Fork it ( https://github.com/vghn/vscripts/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request


## License
See [LICENSE](LICENSE)


## Changelog
See [CHANGELOG](CHANGELOG.md)
