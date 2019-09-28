wsk=/usr/local/bin/wsk
auth=$(< $HOME/tmp/openwhisk/src/ansible/files/auth.guest)

exists() {
  command -v "$1" >/dev/null 2>&1
}

isJavaExist=false
if  exists java ; then
	isJavaExist=true
fi

isGradleExist=false
if  exists gradle ; then
	isGradleExist=true
fi

isCargoExist=false
if  exists cargo ; then
	isCargoExist=true
fi

isBallerinaExist=false
if  exists ballerina ; then
	isBallerinaExist=true
fi

echo "isJavaExist = $isJavaExist"
echo "isGradleExist = $isGradleExist"
echo "isCargoExist = $isCargoExist"
echo "isBallerinaExist = $isBallerinaExist"

if [ "$1" == "auth" ]; then
	$wsk property set --auth "$auth" --apihost https://192.168.0.104 -i
fi


if [ "$1" == "update" ]; then
	$wsk -i action update helloNode src/main/js/hello.js
	$wsk -i action update helloGo src/main/go/hello.go
	if "$isJavaExist" && "$isGradleExist" ;then
		gradle build
		$wsk -i action update helloJava hello.jar --main Hello --docker openwhisk/java8action
	fi
	#$wsk -i action update helloRust src/main.rs
	
	if "$isBallerinaExist" ;then
		ballerina build src/main/ballerina/hello.bal
		$wsk -i action update helloBallerina hello.balx --docker openwhisk/action-ballerina-v0.990.2:nightly
	fi

	echo \
	'#!/bin/bash
	echo "{\"msg\":\"Hello World\"}"' > exec
	chmod +x exec
	zip myAction.zip exec
	$wsk -i action update helloScript myAction.zip --docker openwhisk/dockerskeleton:1.3.2
	rm myAction.zip && rm exec
	
fi


if [ "$1" == "invoke" ]; then
	if "$isJavaExist" && "$isGradleExist" ;then
		$wsk -i action invoke helloJava  -r
	fi
	$wsk -i action invoke helloGo -r
	$wsk -i action invoke helloNode -r
	$wsk -i action invoke helloScript -r
	$wsk -i action invoke helloBallerina -r

	$wsk -i action invoke helloJava  -r -p name pwera
	$wsk -i action invoke helloGo  -r -p name pwera
	$wsk -i action invoke helloNode -r -p name pwera


fi


$wsk   -i action list
