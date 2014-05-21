# VScripts
  [![Build Status](https://travis-ci.org/vghn/vscripts.svg?branch=master)](https://travis-ci.org/vghn/vscripts)
  [![Code Climate](https://codeclimate.com/github/vghn/vscripts.png)](https://codeclimate.com/github/vghn/vscripts)

Automation daemon.

## Dependencies
- Ruby >= 1.9.3
- An AWS account (you'll need to create):
  - A SNS Queue (optional, will attempt to create if can't be found)
  - A Route53 zone.

## Installing

### Gem installation
`gem install vscripts`


## Usage

```
vscripts GLOBAL-OPTIONS COMMAND OPTIONS
```


### Global Options:
```
  -h|--help: Displays VScripts help.
  -v|--version: Displays the version number.
```


### Commands:

1. **Tags2Facts**
  This command can only be run on an AWS EC2 instance. It looks for all tags
associated with it and dumps them in a JSON file. By default this file is
`/etc/facter/facts.d/ec2_tags.json`. It can be overridden with the
***`--file`*** argument.
The `Name` and `DOMAIN` tags are excluded by default because this command is
intended to add Facter facts and these 2 already exist in Facter. This behaviour
can be overridden by adding `[-a|--all]` command line option.

    > **Options**:
    ```
--file, -f <s>: The file that will store the tags (default:
                /etc/facter/facts.d/ec2_tags.json)
--all,  -a: Collect all tags
--help, -h: Shows help
    ```

    > **EXAMPLES**:
    ```
$ vscripts tags2facts
$ vscripts tags2facts --file /tmp/my_tags.json --all
    ```


## Contributing

1. Fork it ( https://github.com/vghn/vscripts/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
