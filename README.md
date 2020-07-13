# Captive - Ruby Subtitle Editor and Converter

Captive can read subtitles from various formats. Subtitles can be modified and exported to another format as well as JSON. Captive currently supports `SRT` and `WebVTT` formats.

## Supported Features

- Read subtitles
- Convert to another format (SRT, WebVTT)
- Save to file
- Serialize as JSON


## Usage

**Parse subtitles**

Subtitles can be read from a file using `from_file` and providing a filename

```ruby
s = Captive::SRT.from_file(filename: 'test.srt')

s = Captive::VTT.from_file(filename: 'test.vtt')
```

Alternately, subtitles can be parsed from a blob of text if you don't want to load from a file
```ruby
s = Captive::SRT.from_blob(filename: 'test.srt')

s = Captive::VTT.from_blob(filename: 'test.vtt')
```

Or to get instantiate an empty captive object simply
```ruby
s = Captive::SRT.new

s = Captive::VTT.new
```

**Save to File**

Subtitles can be saved to a file using `save_as`
```ruby
s = Captive::VTT.from_file(filename: 'test.vtt')
s.save_as(filaname: 'output.vtt')
```

**Serializing as JSON**

Need to store your subtitle data in a format agnostic way? `as_json` is your friend
```ruby
s = Captive::VTT.from_file(filename: 'test.vtt')
s.as_json
```

**Switch Formats**

Subtitles parsed in one format can be converted to another format. Currently, **SRT** and **WebVTT** are supported.

```ruby
s = Captive::SRT.new('test.srt')
vtt = s.as_vtt # Will return a Captive::VTT instance
vtt.save_as(filename: 'conversion.vtt')
```


## Installation

Simply add `captive` to your Gemfile

```ruby
gem 'captive'
```

Or install it yourself with:

    $ gem install captive

## Dependencies

Captive is lightweight and has no external dependencies.

## Development

After cloning the repo, run `bundle install` to get the development dependencies. Use `bin/console` to spin up an IRB instance with captive loaded.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/mserran2/captive.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

