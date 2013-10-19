# VhdlTestScript

This is DSL with Ruby to create VHDL test bench easily and test runner.

## Dependency

This uses GHDL for compiling and running VHDL.  Please download from [GHDL Main/Home Page](http://ghdl.free.fr), and install.

## Installation

    $ gem install vhdl_test_script

Install GHDL from [GHDL Main/Home Page](http://ghdl.free.fr).

## Issues And Features

If you found a bug (or unexpected movement), let me know.  Please attach your vhd file (as far as possible), and describe your intention precisely.

Any feature request is welcome.  I appreciate if it have an example, or a test case.

I am noob about hardware, and VHDL.  If you have knowledge about hardware testing, give me advice.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Write tests with rspec for your changes
5. Push to the branch (`git push origin my-new-feature`)
6. Create new Pull Request

## References

Utility functions in a generated test file are from http://www.eda-stds.org/vhdl-200x/vhdl-200x-ft/packages_old/ .
