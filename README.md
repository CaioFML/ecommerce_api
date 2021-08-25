# README

This is an project of ecommerce made with bootcamp of OnebitCode!

## Setup 

### Prerequisites

The setups steps expect following tools installed on the system.

- Git
- Ruby 2.7.1
- Rails 6.0.3.4

1. Clone this repository:

```
    $ git clone git@github.com:CaioFML/ecommerce_api.git
```

2. Go to the folder and bundle install:

```
    cd ecommerce_api
    bundle install
```

3. Create, setup the database and run task to populate database:

```
    $ rails db:setup
    $ rails dev:prime
```

4. Running tests:

```
    $ rails db:test:prepare
    $ bundle exec rspec
```

5. Running rubocop:

```
    $ bundle exec rubocop
```

6. Import this file on postman to see the model of endpoints:

[Model of endpoints postman](https://drive.google.com/file/d/1J_nygNiWBJNwdIFewSkEVqlS7RgthJrR/view?usp=sharing)