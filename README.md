# websms

The ruby way to deal with websms - send and access your SMS easily.

## INSTALLATION
For installation simply run:

    gem install websms

## Usage
Example usage:

    browser = Websms::O2online.new
    browser.login(<user>, <password>)

    smss = browser.get_archive_page 3


Check the examples folder for more comprehensive ones.

## TODO
  * gmail support
  * clickatell support
  * other web SMS provider
  * send SMS
  * define with proper API

## Contributing

We'll check out your contribution if you:

  * Fork the project.
  * Make your feature addition or bug fix.
  * Add tests for it. This is important so I don't break it in a
    future version unintentionally.
  * Commit, do not mess with rakefile, version, or history.
    (if you want to have your own version, that is fine but bump version in a commit by itself I can ignore when I pull)
  * Make a pull request. Bonus points for topic branches.

## License

The license is included as LICENSE in this directory.
