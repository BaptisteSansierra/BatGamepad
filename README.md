# BatGamepad

A gamepad for games or something else …


## Features

* Add a directional pad to selected view
* Add a set of buttons (1, 2, 3 or 4) to selected view

## Examples

The repo includes the following example project that can be used as templates or for testing purposes
* BatGamepadExample.xcodeproj

![Image](https://github.com/BaptisteSansierra/BatGamepad/blob/master/gamepadScreenshot.png)
                   
## Requirements

* ARC memory management.

## Usage

On your project:
* Initialize an instance of a BatGamepad passing in :
- config flags : BAT_GAMEPAD_DPAD_BIT to display a directional pad, BAT_GAMEPAD_BUTTON(1/2/3/4)_BIT to display button 1/2/3/4.
- parent view
- parent view controller
- an object for delegate 
* Configure delegate object to receive dpad and buttons callbacks
	
## License

Copyright (c) 2013 Joan Lluch <joan.lluch@sweetwilliamsl.com>

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is furnished
to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
