# VhdlTestScript

VhdlTestScript is a test-driven development Tool for VHDL  
(This Project is forked from [tomykaira/vhdl_doctest](https://github.com/tomykaira/vhdl_doctest))

## Dependency

This uses GHDL for compiling and running VHDL.  Please download from [GHDL Main/Home Page](http://ghdl.free.fr), and install.

## Installation

    $ git clone git@github.com:tomoasleep/vhdl_test_script.git
    $ cd vhdl_test_script
    $ rake install

Install GHDL from [GHDL Main/Home Page](http://ghdl.free.fr).

## Usage

To use VhdlTestScript, you write test benches with ruby like this.

```ruby
VhdlTestScript.scenario DUT_PATH do |dut|
  # please write your test scenario here

  # Example:
  # 'a' is 'in' port , 'output' is 'out' port.
  # declare port to use test as ':a' or 'dut.a'
  ports :a, :output

  # to use 'in' port 'clk' as clock.
  clock :clk

  # when 'a' is assigned '1' before rising edge,
  # 'output' is expected to be '1' after clock.
  step 1, 1

  step 2, 2

  # '_' means 'don't assign' or 'don't care'.
  step _, 2
  step 1, _

  # you can use 'step' like this
  step a: 1, output: 1
end
```

this ruby test bench is converted into a VHDL test bench when run vhdltestscript

Documentation of test scenario syntax is being developed now.
Please read example codes in /example to know how to write test scenario.

## Issues And Features

If you found a bug (or unexpected movement), let me know.  Please attach your vhd and test bench file (as far as possible), and describe your intention precisely.

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
