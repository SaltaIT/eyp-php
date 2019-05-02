# CHANGELOG

## 0.6.1

* Updated metadata for **eyp-systemd 0.2.0**

## 0.6.0

* **INCOMPATIBLE CHANGE**
  - renamed **php** and **php::fpm** variables to match PHP's name:
    - error_log
    - allow_url_fopen
    - allow_url_include
    - expose_php
    - max_execution_time
    - memory_limit
    - upload_max_filesize
    - post_max_size
    - process_max
    - process_priority

## 0.5.2

* added magic_quotes variables

## 0.5.1

* added CentOS 6 support on **php::apache**

## 0.5.0

* Added CentOS 7 compatibility for **php::fpm**
* Added support for **IUS repo**
* Added supoort for pear packages using **php::pear**
* **INCOMPATIBLE CHANGES**:
  - changed default listen for **php::fpmpool** to **/var/run/php-fpm.sock**
  - renamed:
    - **php::fpmpool** to **php::fpm::pool**

## 0.4.13

* split **php::mysqlnd_ms** to have a general **php::mysqlnd** class

## 0.4.12

* added mysqlnd_ms under puppet management

## 0.4.11

* changed **while true** to **yes** for pecl install

## 0.4.10

* dropped deprecated tag support

## 0.4.9

* deleting pecl install log file

## 0.4.8

* install pecl dependencies

## 0.4.7

* improved compatibility for **php::pecl**

## 0.4.5

* **php::enablemodule** priority typo and improved puppet compatibility

## 0.4.3

* **php::enablemodule** improved service notifications

## 0.4.2

* added **ioncube** support

## 0.4.1

* removed puppetlabs-apt, code rewritten to be able to use **eyp-apt**
* improved **php::module['phalcon']** and **php::maxmind** support by automatically adding the **PPA**
* added support for **Ubuntu 16.04**

## 0.3.0

* minor changes: lint
* bugfix OS detection
* dropped tag support
