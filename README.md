![alt text](https://github.com/theOSPF/xrandr-strapping/blob/master/assets/xrandrs.png "Logo Title Text")

## Description

Xrandrs is ultimate lightweight command-line tool (strapping) writed on bash, designed for configuration management via xrandr (official configuration utility to the [RandR](https://en.wikipedia.org/wiki/RandR "wikipedia:RandR") (_Resize and Rotate_) [X Window System](https://en.wikipedia.org/wiki/X_Window_System "wikipedia:X Window System") extension).

![alt text](https://github.com/theOSPF/xrandr-strapping/blob/master/assets/xrandrs.gif "Gif file")

## Installation

```shell
sudo wget -O /usr/bin/xrandrs https://github.com/theOSPF/xrandr-strapping/blob/master/xrandr_home.sh
```


## Autostart

#### Awesome

`os.execute("pgrep -u $USER -x xrandrs || (xrandrs &)")
`
