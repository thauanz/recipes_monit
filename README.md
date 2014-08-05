recipes_monit
=============

Recipe for monit capistrano

Sets the monit for the following items:

* Elasticsearch
* Mysql
* Nginx
* Postfix
* Puma
* Redis

## Setup

Clone the repository in your project folder **/config/recipes**

```
git clone git@github.com:thauanz/recipes_monit.git your_project/config/recipes
```

## Configuration

You add in your file **deploy.rb** this line

```
load "config/recipes/monit"
```

This version install monit for CentOS

```
bundle exec cap monit:install
```

And to configure the server monit

```
bundle exec cap monit:setup
```
