wsk=/usr/local/bin/wsk
auth=$(< $HOME/tmp/openwhisk/src/ansible/files/auth.guest)

exists() {
  command -v "$1" >/dev/null 2>&1
}

if [ "$1" == "auth" ]; then
	$wsk property set --auth "$auth" --apihost https://192.168.0.104 -i
fi


if [ "$1" == "update" ]; then
	#$wsk -i action update sdkNode src/main/js/hello.js --kind nodejs:10
	cd src && zip ../hello-src.zip -qr * && cd .. && \
	$wsk -i action update sdkGolang hello-src.zip --main hello --docker openwhisk/actionloop-golang-v1.11 && rm hello-src.zip
fi


if [ "$1" == "invoke" ]; then
	$wsk -i action invoke sdkGolang -b
fi


$wsk   -i action list
