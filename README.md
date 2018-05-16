# Verkkaaja
Shopping assistant for Finnish online retail store Verkkokauppa.com

[![Build Status](https://travis-ci.org/kmikko/verkkaaja.svg?branch=master)](https://travis-ci.org/kmikko/verkkaaja)

![verkkaaja](https://user-images.githubusercontent.com/2776729/31810379-38a3eb74-b584-11e7-8de3-f866464d4a9f.gif)

## Requirements
 - [jq](https://github.com/stedolan/jq)
 - [pup](https://github.com/ericchiang/pup)
 - [Verkkokauppa.com account](https://www.verkkokauppa.com/)

## Usage
Run script, provide your login details and URL of the product you wish to reserve
```sh
./verkkaaja.sh
```

...or run in a Docker container:
```sh
docker build -t verkkaaja .
docker run verkkaaja --login [username] --password [password] --url [product-url]
```

Happy hunting!

## Contribution
Format your code using [shfmt](https://github.com/mvdan/sh) and according to [Google's Shell Style Guide](https://google.github.io/styleguide/shell.xml)
using `shfmt -i 2 -ci -w verkkaaja.sh`

## License
MIT
