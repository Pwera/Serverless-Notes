## Kubeless
## OpenWhisk

``` 
    git clone https://github.com/apache/openwhisk-devtools.git
    cd openwhisk-devtools/docker-compose
    make quick-start
```
Install OpenWhisk 

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

## Kuma
 
