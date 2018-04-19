# Verkkaaja
Shopping assistant for Finnish online retail store Verkkokauppa.com


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

## License
MIT
