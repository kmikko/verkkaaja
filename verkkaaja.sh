#!/bin/bash

while [[ $# -gt 0 ]]; do
  case $1 in
  --login)
  EMAIL="$2"
  shift 2
  ;;
  --password)
  PASS="$2"
  shift 2
  ;;
  --url)
  PRODUCT_URL="$2"
  shift 2
  ;;
  *)
  echo "Unknown option: $1"
  exit 1
  ;;
esac
done

if [ -z "$EMAIL" ]; then
  read -p 'Email: ' EMAIL
fi
if [ -z "$PASS" ]; then
  read -sp 'Password: ' PASS
fi
if [ -z "$PRODUCT_URL" ]; then
  echo
  read -p 'Product URL: ' PRODUCT_URL
fi

# Login
TOKEN=$(curl -s -f 'https://www.verkkokauppa.com/resp-api/login' \
-H 'Origin: https://www.verkkokauppa.com' \
-H 'Accept-Encoding: gzip, deflate, br' \
-H 'Accept-Language: en-US,en;q=0.8,fi;q=0.6' \
-H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/61.0.3163.100 Safari/537.36' \
-H 'Content-Type: application/json' \
-H 'Accept: */*' \
-H 'Referer: https://www.verkkokauppa.com/fi/account/login/' \
-H 'Connection: keep-alive' \
--data-binary '{"email":"'$EMAIL'","password":"'$PASS'"}' --compressed)

if [ 0 -eq $? ]; then
  echo Login succesful...
  TOKEN=$(echo $TOKEN | jq '.track' | sed 's/\"//g')
else
  echo ERROR: Login failed
  exit 1;
fi

# Get shopping cart
CART=$(curl -s 'https://www.verkkokauppa.com/api/v2/mycart' \
-H 'Authorization: Bearer '$TOKEN \
-H 'Accept-Encoding: gzip, deflate, br' \
-H 'Accept-Language: en-US,en;q=0.8,fi;q=0.6' \
-H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/61.0.3163.100 Safari/537.36' \
-H 'Accept: */*' \
-H 'Referer: https://www.verkkokauppa.com/fi/account/' \
-H 'Connection: keep-alive' --compressed)

if [ 0 -eq $? ]; then
  echo Shopping cart fetched...
  CART=$(echo $CART | jq '.cartUuid' | sed 's/\"//g')
else
  echo ERROR: Could not fetch shopping cart
  exit 1;
fi

# Get product SKU
SKU=$(curl -s $PRODUCT_URL)

if [ 0 -eq $? ]; then
  echo Product information fetched...
  SKU=$(echo $SKU | pup 'meta[itemprop="sku"] attr{content}')
else
  echo ERROR: Could not fetch product info
  exit 1;
fi

echo Trying to add product to shopping cart...
# Release the hounds
while true; do
  ERRORS=$(curl -s "https://www.verkkokauppa.com/api/v2/cart/${CART}?pid=${SKU}&quantity=1" \
    -X PUT \
    -H 'Authorization: Bearer '$TOKEN \
    -H 'Origin: https://www.verkkokauppa.com' \
    -H 'Accept-Encoding: gzip, deflate, br' \
    -H 'Accept-Language: en-US,en;q=0.8,fi;q=0.6' \
    -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/61.0.3163.100 Safari/537.36' \
    -H 'Accept: */*' \
    -H 'Referer: '$PRODUCT_URL \
    -H 'Connection: keep-alive' \
    -H 'Content-Length: 0' \
    --compressed | jq '.errors')

  if [ 4 -eq $? ]; then
    echo Failed to parse response...
    sleep 1
  else
    NO_ERRORS=$(echo $ERRORS | jq '. | length == 0')

    if $NO_ERRORS; then
      echo Product reserved. Quitting...
      exit 0;
    fi
    echo $ERRORS
  fi

  echo Trying again...
done
