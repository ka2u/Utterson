use inc::Module::Install;
use Module::Install::ReadmeFromPod;
use Module::Install::AuthorTests;
use Module::Install::Repository

name 'Utterson';
all_from 'lib/Utterson.pm';
readme_from('lib/Utterson.pm');

requires 'Mojolicious';
requires 'Plack';
requires 'Text::Xatena';
requires 'YAML::Tiny';
requires 'File::Path';
requires 'Digest::SHA1';
build_requires 'Test::More';
test_requires 'Test::Requires';

tests 't/*.t t/*/*.t t/*/*/*.t t/*/*/*/*.t t/*/*/*/*/*.t';
author_tests('xt');

auto_install;
auto_set_repository;
WriteAll;
