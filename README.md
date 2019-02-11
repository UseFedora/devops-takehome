# DevOps take-home

In this repository you'll find a very simple Ruby web application. Your job is
to write some scripts that will deploy this application. You can use any tool
you feel comfortable with, for instance Docker Compose, Terraform, Ansible,
Chef, and Puppet.

When you get in for an interview, we expect you to explain your code and
justify the choices you made.

**NB:** If you have something similar that you can share, you don't need to do this
exercise. We don't expect you to spend more than an hour or so doing this.

If you want to keep your work private from your current employer, please invite
[iain](https://github.com/iain) or [elijah](https://github.com/Elmuch) as a
collaborator.

## Instructions

The app depends on an environment variable called `DATABASE_URL`. This variable
needs to be a connection URL for PostgreSQL.

To install dependencies:

```
$ gem install bundler && bundle install
```

To migrate the database.

```
$ ruby db/migrate.rb
```

To run unit tests:

```
$ bundle exec rspec
```

To run server:

```
$ bundle exec puma
```
