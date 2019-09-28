## Kubeless
## OpenWhisk

``` 
    git clone https://github.com/apache/openwhisk-devtools.git
    cd openwhisk-devtools/docker-compose
    make quick-start
```
Install OpenWhisk 

``` 
    This repository contains ready to run polyglot examples of OpenWhisk
    1) hello/ contains java, node, go, (rust & ballerina in progress) serverless functions that by default print hello world, or hello <arg> if arg was passed.

```

``` 
    package main

    import "fmt"

    // Main function for the action
    func Main(obj map[string]interface{}) map[string]interface{} {
    name, ok := obj["name"].(string)
    if !ok {
        name = "stranger"
    }
    fmt.Printf("name=%s\n", name)
    msg := make(map[string]interface{})
    msg["msg"] = "Hello, " + name + "!"
    return msg
}
```
hello.go

``` 
    packages:
    default:
        actions:
            helloGo:
                function: hello.go
```
manifest.yaml

``` 
    // Create action
    wsk action create helloGo hello.go
    // Invoke action
    wsk action invoke helloGo -r -p name gopher
    // deploy
    wskdeploy -m manifest.yaml

```
OpenWhisk Go helloworld steps

``` 
    package hello;

    import com.google.gson.JsonObject;

    public class Hello {
    public static JsonObject main(JsonObject args){
        String name;

        try {
            name = args.getAsJsonPrimitive("name").getAsString();
        } catch(Exception e) {
            name = "stranger";
        }

        JsonObject response = new JsonObject();
        response.addProperty("greeting", "Hello " + name + "!");
        return response;
    }
}
```
Hello.java

``` 
    javac Hello.java
    jar cvf hello.jar Hello.class
    // Create Action
    wsk action create helloJava hello.jar --main Hello
    // Invoke action
    wsk action invoke helloJava --blocking --result

```
OpenWhisk Java helloworld steps

OpenWhisk allows to deploy to:
- Kubernetes
- Mesos
- OpenShift
- Vagrant
- Docker Compose

Event providers:
- Alarms (scheduled task)
- CouchDB
- Github
- Kafka
- RSS

OpenWhisk actions sandboxes in docker container.
OpenWhisk ecosystem allows to run short scalable functions in a serverless fashion.
Commercial: bluemix.net/openwhisk

API Gateway
When you want to do more  with HTTP endpoints
- Route endpoints methods to actions
- Custom domains
- Rate limiting
- Security 
- Analytics

Packages
- Group of actions together
- Set parameters used by all actions

Sequences
Invoke a set of actions in turn

``` 
    wsk property set --auth "$auth" --apihost https://192.168.0.104 -i
    wsk -i action list
    wsk -i action create helloJava main.jar --main Main --web true --docker openwhisk/java8action
    wsk action get --url helloJava

```
OpenWhisk flow


## Kuma
 


Sources:

Adventures in Apache Openwhisk - Rob Allen

Apache OpenWhisk: How it Works and How You Can Benefit - Carlos Santana, IBM
