# php

**NTTCom-MS/eyp-php**: [![Build Status](https://travis-ci.org/NTTCom-MS/eyp-php.png?branch=master)](https://travis-ci.org/NTTCom-MS/eyp-php)

#### Table of Contents

1. [Overview](#overview)
2. [Module Description](#module-description)
3. [Setup](#setup)
    * [What php affects](#what-php-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with php](#beginning-with-php)
4. [Usage](#usage)
5. [Reference](#reference)
5. [Limitations](#limitations)
6. [Development](#development)

## Overview

php: cli, mod_php and php-fpm management

## Module Description

This module can work alongside with **eyp-apache** to enable mod_php

## Setup

### What php affects

* A list of files, packages, services, or operations that the module will alter,
  impact, or execute on the system it's installed on.
* This is a great place to stick any warnings.
* Can be in list or paragraph form.

### Setup Requirements

### Beginning with php

```yaml
fpm:
  phpfpm:
    user: bbt-deploy
fpmpool:
  www:
    listen: 0.0.0.0:9000
    user: bbt-deploy
    env:
      APPLICATION_ENV: pro
    maxchildren: 30
    maxspareservers: 6
```
mysqlns_ms example:
```puppet
class{ 'php::mysqlnd_ms': }

php::mysqlnd_ms::datasource { "ndtest":
}

php::mysqlnd_ms::master { "master0":
  datasource_name => 'ndtest',
}

php::mysqlnd_ms::slave { "slave1":
  datasource_name => 'ndtest',
}

php::mysqlnd_ms::slave { "slave2":
  datasource_name => 'ndtest',
}

php::enablemodule { 'mysqlnd cli':
  modulename => 'mysqlnd',
  instance => 'cli',
}

php::enablemodule { 'mysqlnd apache':
  modulename => 'mysqlnd',
  instance => 'apache2',
}
```

## Usage

Put the classes, types, and resources for customizing, configuring, and doing
the fancy stuff with your module here.

## Reference

Here, list the classes, types, providers, facts, etc contained in your module.
This section should include all of the under-the-hood workings of your module so
people know what the module is touching on their system but don't need to mess
with things. (We are working on automating this section!)

## Limitations

* Ubuntu:
  * php-cli
  * php-fpm
  * mod_php
* RedHat 7 and derivatives
  * php-cli
  * php-fpm

## Development

We are pushing to have acceptance testing in place, so any new feature should
have some test to check both presence and absence of any feature
