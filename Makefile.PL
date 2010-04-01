use inc::Module::Install;
use Module::Install::ReadmeFromPod;
use Module::Install::AuthorTests;
use Module::Install::Repository

name 'Hyde';
all_from 'lib/Hyde.pm';
readme_from('lib/Hyde.pm');

requires 'Mojolicious';
requires 'Plack';
requires 'Text::Xatena';
requires 'YAML::Tiny';
requires 'File::Path';
build_requires 'Test::More';
test_requires 'Test::Requires';

tests 't/*.t t/*/*.t t/*/*/*.t t/*/*/*/*.t t/*/*/*/*/*.t';
author_tests('xt');

auto_install;
auto_set_repository;
WriteAll;
