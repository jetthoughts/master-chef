### Guidelines

 - [Workfow](https://github.com/bigbinary/workflow)
 - [Credentials](https://github.com/bigbinary/wheel/wiki/Credentials)
 - [Using PostgreSQL](https://gist.github.com/neerajdotname/f3f22aff617e753bc051)

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
