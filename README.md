Master Chef
===========

<Description goe here>

### Setting up development machine

``` ruby
bundle install
rake setup
bundle exec rails server
```

Start server and login with following credentials

```
email: john@example.com
password: welcome
```


### Running tests

``` ruby
# to execute all tests
rake 

# to execute tests in models
rake test:models

# to execute tests in controllers
rake test:controllers

# running an individual test file
rake test test/models/comment_test.rb
```
