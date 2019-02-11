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

Install dependencies:

```
$ gem install bundler && bundle install
```

Make sure you have a PostgreSQL database for this application and make sure the
application knows about it via the `DATABASE_URL` environment variable.

For example:

```
$ export DATABASE_URL="postgres://localhost:5432/devops_test"
```

Migrate the database.

```
$ ruby db/migrate.rb
```

Run unit tests:

```
$ bundle exec rspec
```

Run the web server:

```
$ bundle exec puma
```
