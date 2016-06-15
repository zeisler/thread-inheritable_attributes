# Thread Inheritable Attributes

Passes thread variables to child spawned threads. Main use case is enabling logging in child thread to keep context of a request.

## Installation

Add this line to your application's Gemfile:

```ruby
gem "thread-inheritable_attributes"
```

[request_store](https://github.com/steveklabnik/request_store) is an optional dependency for when working within the context of a multi-threaded web server. 

If using Rails no config is required, except including the gem. When using other Rack based frameworks see [docs](https://github.com/steveklabnik/request_store#no-rails-no-problem) for including middleware.

```ruby
gem "request_store"
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install thread-inheritable_attributes

## Usage

```ruby
require "thread/inheritable_attributes"

Thread.current.set_inheritable_attribute(:request_id, SecureRandom.uuid)

thread = Thread.new {
          Thread.current.get_inheritable_attribute(:request_id)
        }
thread.join
thread.value
  #=> "80f58e0f-0564-487d-8f92-4cff8237af24"
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/zeisler/thread_variable_cascade. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

