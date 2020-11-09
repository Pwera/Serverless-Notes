# OpenWhisk

###### Install OpenWhisk 
``` bash
    git clone https://github.com/apache/openwhisk-devtools.git
    cd openwhisk-devtools/docker-compose
    make quick-start
```

###### About repository 
``` 
    This repository contains ready to run polyglot examples of OpenWhisk
    1) hello/ contains java, node, go, (rust & ballerina in progress) serverless functions that by default print hello world, or hello <arg> if arg was passed.

```

###### Actions
Actions are stateless code snippets (functions) that run on the ICF platform. The platform supports functions written in JavaScript (Node.js), Python, PHP, Ruby or Swift as well as many other programming languages. It also supports functions implemented as executables (binary programs) packaged in Docker containers.

Actions can be used to do many things. For example, an action can be used to respond to a database change, aggregate a set of API calls, post a Tweet, or even work with AI and analytics services to detect objects in an image or streamed video.

Actions can be explicitly invoked or run in response to an event. In either case, each run of an action results in an activation record that is identified by a unique activation ID. The input to an action and the result of an action are a dictionary of key-value pairs, where the key is a string and the value a valid JSON value. Actions can also be composed of calls to other actions or a defined sequence of actions.
value a valid JSON value. Actions can also be composed of calls to other actions or a defined sequence of actions.

###### Create and invoke actions
Create Node.js / Go / Java actions

<table>
<tr>
<td>
</td>
<td>
Node
</td>
<td>
Go
</td>
<td>
Java
</td>
<td>
Rust
</td>
<td>
Ballerina
</td>
</tr>
<tr>
<td>
1. Create a file named hello.abc with these contents
</td>
<td>

  ``` node
function main() {
    return {payload: 'Hello world'};
    }
```
</td>
<td>

 ``` go
    package main

    func Main(obj map[string]interface{}) map[string]interface{} {
    msg := make(map[string]interface{})
    msg["payload"] = "Hello World"
    return msg
}
```
</td>
<td>

``` java
    package hello;

    import com.google.gson.JsonObject;

    public class Hello {
    public static JsonObject main(JsonObject args){
        JsonObject response = new JsonObject();
        response.addProperty("payload", "Hello World");
        return response;
    }
}
```
</td>
<td>
Rust
</td>
<td>

``` code
import ballerina/io;

public function main(json jsonInput) returns  json? {
  io:println(jsonInput);
  json output = { "response": "hello-world"};
  return output;
}
```
</td>
</tr>


<tr>
<td>

</td>
<td>

``` bash
ibmcloud fn action create hello hello.js
```

</td>
<td>

``` bash
 wsk action create hello hello.go
```

</td>
<td>

``` bash
    javac Hello.java
    jar cvf hello.jar Hello.class
    wsk action create hello hello.jar --main Hello
```

</td>
<td>

``` rust
wsk -i action create helloRust src/main.rs --docker openwhisk/action-rust-v1.34
```
<td>

``` bash
ballerina build hello.bal
wsk -i action create hello hello.balx --docker openwhisk/action-ballerina-v0.990.2:nightly
```
</td>
</tr>


</table>


``` bash
ok: created action hello
```
3. List all actions. The hello action you just created should show:

``` bash
ibmcloud fn action list
```
```bash
actions
<NAMESPACE>/hello       private    nodejs10
```
###### Invoke actions
After you create your action, you can run it on ICF with the invoke command using one of two modes:
- Blocking which will wait for the result (like request and response style) by specifying the --blocking flag on the command line.

- Non-blocking which will invoke the action immediately, but not wait for a response.

Regardless, invocations always provide an activation ID. This can be used later to lookup the action's response which is part of an activation record the platform creates for each invocation.

###### Blocking invocations

A blocking invocation request will wait for the activation result to be available.
1. Invoke the hello action using the command line as a blocking activation:
``` bash
ibmcloud fn action invoke --blocking hello
```
The command outputs the activation ID (44794bd6aab74415b4e42a308d880e5b) which can always be used later to lookup the response:

``` bash
ok: invoked /_/hello with id 44794bd6aab74415b4e42a308d880e5b
```
The command outputs the complete activation record in JSON format which contains all information about the activation, including the function's complete response. The JavaScript function's output is the string Hello world which appears as the value of the payload key:
```json
...
"response": {
      "result": {
          "payload": "Hello world"
      },
      "size": 25,
      "status": "success",
      "success": true
  },
  ...
```
###### Non-blocking invocations
A non-blocking invocation will invoke the action immediately, but not wait for a response.

If you don't need the action result right away, you can omit the --blocking flag to make a non-blocking invocation. You can get the result later by using the activation ID.
1. Invoke the hello action using the command line as a non-blocking activation:
```bash
ibmcloud fn action invoke hello
```
2. Retrieve the activation result using the activation ID from the invocation:

``` bash
ibmcloud fn activation result 6bf1f670ee614a7eb5af3c9fde81304
```

```json
{
    "payload": "Hello world"
}
```
3. Retrieve the full activation record. To get the complete activation record use the activation get command using the activation ID from the invocation:
``` bash
ibmcloud fn activation get 6bf1f670ee614a7eb5af3c9fde813043
```
``` json
ok: got activation 6bf1f670ee614a7eb5af3c9fde813043
{
  ...
  "response": {
      "result": {
          "payload": "Hello world"
      },
      "size": 25,
      "status": "success",
      "success": true
  },
  ...
}
```
###### Retrieve activation records

``` bash
ibmcloud fn activation get --last
```

###### Retrieve the last activation result
``` bash
ibmcloud fn activation result --last
```

###### Retrieve the recent activation list
```bash
ibmcloud fn activation list
```

###### Invoke an action with parameters
Event parameters can be passed to an action's function when it is invoked. Let's look at a sample action which uses the parameters to calculate the return values.


<table>
<tr>
<td>
</td>
<td>
Node
</td>
<td>
Go
</td>
<td>
Java
</td>
<td>
Rust
</td>
</tr>
<tr>
<td>
Update the file hello.abc with the following source code:
</td>
<td>

``` js
function main(params) {
    return {payload:  'Hello, ' + params.name};
}
```
</td>
<td>

 ``` go
    package main

    func Main(obj map[string]interface{}) map[string]interface{} {
    name, ok := obj["name"].(string)
    if !ok {
        name = "Stranger"
    }
    msg := make(map[string]interface{})
    msg["payload"] = "Hello, " + name
    return msg
}
```
</td>
<td>

``` java
    package hello;

    import com.google.gson.JsonObject;

    public class Hello {
    public static JsonObject main(JsonObject args){
        String name;

        try {
            name = args.getAsJsonPrimitive("name").getAsString();
        } catch(Exception e) {
            name = "Stranger";
        }

        JsonObject response = new JsonObject();
        response.addProperty("payload", "Hello, " + name);
        return response;
    }
}
```
</td>
<td>

``` Rust
extern crate serde_json;

use serde_derive::{Deserialize, Serialize};
use serde_json::{Error, Value};

#[derive(Debug, Clone, PartialEq, Serialize, Deserialize)]
struct Input {
    #[serde(default = "stranger")]
    name: String,
}

#[derive(Debug, Clone, PartialEq, Serialize, Deserialize)]
struct Output {
    body: String,
}

fn stranger() -> String {
    "World".to_string()
}

pub fn main(args: Value) -> Result<Value, Error> {
    let input: Input = serde_json::from_value(args)?;
    let output = Output {
        body: format!("Hello, {}", input.name),
    };
    serde_json::to_value(output)
}
```
</td>
</tr>
<tr>
</tr>
<td>
Update the hello action
</td>
<td>

``` bash
ibmcloud fn action update hello hello.js
```
</td>
<td>

``` bash
ibmcloud fn action update hello hello.go
```
</td>
<td>

``` bash
wsk action update hello hello.jar --main Hello
```
</td>
<td>

``` bash 
wsk -i action update helloRust src/main.rs --docker openwhisk/action-rust-v1.34
```
</td>
</table>

###### Invoke using the command line parameters
``` bash
ibmcloud fn action invoke --result hello --param name Elrond
```

``` bash
{
    "payload": "Hello, Elrond"
}
```

In the invocation above, the --result option was used. This flag implies a blocking invocation where the command-line interface (CLI) waits for the activation to complete and then displays only the functions resulting output as the payload value.

###### Invoke using parameters declared in a file

You can also pass parameters from a file containing the desired content in JSON format. The filename must then be passed using the --param-file flag.

1. Create a file named parameters.json containing the following JSON:


``` json
{
    "name": "Frodo"
}

```

2. Invoke the hello action using parameters from the JSON file:
``` bash
ibmcloud fn action invoke --result hello --param-file parameters.json
```

###### Bind default parameters
Actions can be invoked with multiple named parameters. Recall that the hello action from the previous example expects two parameters: the name of a person and the place where they're from.

Rather than pass all the parameters to an action every time, you can bind default parameters. Default parameters are stored in the platform and automatically passed in during each invocation. If the invocation includes the same event parameter, this will overwrite the default parameter value.

Update the action by using the --param option to bind default parameter values:

``` bash
ibmcloud fn action update hello --param name Frodo
```

Once parameters are bound, there is no current way to unbind them; you will have to delete the entire action and start over binding only the parameters you want.
Each time the action update subcommand is used to update your function, ICF increments the internal version of your action.


###### Retrieve action logs


<table>
<tr>
<td>
Create a new action named logs
</td>
<td>

``` js
function main(params) {
    console.log("function called with params", params)
    console.error("this is an error message")
    return { result: true }
}
```
</td>
</tr>
</table>

```bash
ibmcloud fn action create logs logs.js
```

``` bash
ok: created action logs
```
Invoke the logs action to generate logs:

```bash
ibmcloud fn action invoke -r logs -p hello world
```

###### Access activation logs

```bash
ibmcloud fn activation get --last
```

``` json
ok: got activation 9fc044881705479580448817053795bd
{
    ...
    "logs": [
        "20xx-11-14T09:49:03.021Z stdout: function called with params { hello: 'world' }",
        "20xx-11-14T09:49:03.021Z stderr: this is an error message"
    ],
    ...
}
```

``` bash
ibmcloud fn activation logs --last
```

``` bash
20xx-11-14T09:49:03.021404683Z stdout: function called with params { hello: 'world' }
20xx-11-14T09:49:03.021816473Z stderr: this is an error message
```

###### Poll activation logs
Activation logs can be monitored in real time, rather than manually retrieving individual activation records.

``` bash
 ibmcloud fn activation poll
```

###### Calling other actions

Create the new action named proxy from the following source files:
<table>
<tr>
<td>
Node
</td>
</tr>
<tr>
<td>

``` js
var openwhisk = require('openwhisk');

function main(params) {
    if (params.password !== 'secret') {
    throw new Error("Password incorrect!")
    }<pre><code>var ow = openwhisk();
return ow.actions.invoke({name: "hello", blocking: true, result: true, params: params})</code></pre>}
```

</td>
</tr>
</table>

``` bash
ibmcloud fn action create proxy proxy.js
```

``` bash
ibmcloud fn action invoke proxy -p password secret -p name Bernie -r
```

Review the activations list to show both actions were invoked:
``` bash
   ibmcloud fn activation list -l 2
```

The function uses the NPM Apache OpenWhisk JavaScript library which is pre-installed in the ICF runtime (so you do not need to package it). Its source code can be found here: https://github.com/apache/openwhisk-client-js/.

###### Return asynchronous results

Actions have a timeout parameter that enforces the maximum duration for an invocation. This value defaults to 60 seconds and can be changed to a maximum of 5 minutes.

```bash
 ibmcloud fn action update asyncAction --timeout 1000
 ```


###### Action sequences
Sequence actions are created using a list of existing actions. When the sequence action is invoked, each action is executed in order of the action parameter list. Input parameters are passed to the first action in the sequence. Output from each function in the sequence is passed as the input to the next function and so on. The output from the last action in the sequence is returned as the response result.

Sequences behave like normal actions. You create, invoke, and manage them as actions through the CLI.



###### Handle errors

If any action within the sequences returns an error, the platform returns immediately. The action error is returned as the response and no further actions within the sequence will be invoked.

```js
 function fail (params) {
    if (params.fail) {
        throw new Error("stopping sequence and returning.")
    }

    return params
  }

  function end (params) {
    return { message: "sequence finished." }
  }
  ```
``` bash 
ibmcloud fn action create fail funcs.js --main fail
ibmcloud fn action create end funcs.js --main end
ibmcloud fn action create example --sequence fail,end
```
```bash 
ibmcloud fn action invoke example -r -p fail true
```

``` json
{
       "error": "An error has occurred: Error: stopping sequence and returning."
}
```

###### Packages
IBM Cloud Functions (ICF) comes pre-installed with a number of public packages, which include trigger feeds used to register triggers with event sources.

Actions in public packages can be used by anyone and the caller pays the invocation cost.

Get a list of packages in the /whisk.system namespace
``` bash
ibmcloud fn package list /whisk.system
```

```bash
packages
   /whisk.system/alarms                      shared
   /whisk.system/cloudant                    shared
   /whisk.system/combinators                 shared
   /whisk.system/cos                         shared
   /whisk.system/github                      shared
   /whisk.system/messaging                   shared
   /whisk.system/pushnotifications           shared
   /whisk.system/samples                     shared
   /whisk.system/slack                       shared
   /whisk.system/utils                       shared
   /whisk.system/watson-speechToText         shared
   /whisk.system/watson-textToSpeech         shared
   /whisk.system/watson-translator           shared
   /whisk.system/weather                     shared
   /whisk.system/websocket                   shared
```
Get a list of entities in the /whisk.system/cloudant package

``` bash
ibmcloud fn package get --summary /whisk.system/cloudant
```

Get a description of the /whisk.system/cloudant/read action
``` bash
ibmcloud fn action get --summary /whisk.system/cloudant/read
```
``` bash
 action /whisk.system/cloudant/read: Read document from database
      (parameters: *apihost, *bluemixServiceName, dbname, *id, params)
```
###### Invoke actions in a package
You can invoke actions in a package, just as with other actions. The next few steps show how to invoke the greeting action in the /whisk.system/samples package with different parameters.
Get a description of the /whisk.system/samples/greeting action:
```bash
ibmcloud fn action get --summary /whisk.system/samples/greeting
```
```bash
action /whisk.system/samples/greeting: Returns a friendly greeting
      (parameters: name, place)
```

```bash
Invoke the action without any parameters
```
```bash
ibmcloud fn action invoke --result /whisk.system/samples/greeting
```



###### Create and use package bindings
Although you can use the entities in a package directly, you might find yourself passing the same parameters to the action every time. You can avoid this by binding to a package and specifying default parameters. These parameters are inherited by the actions in the package.


Bind to the /whisk.system/samples package and set a default place parameter value:
```bash
ibmcloud fn package bind /whisk.system/samples valhallaSamples --param place Valhalla
```
```bash
ok: created binding valhallaSamples
```
Get a description of the package binding:
```bash
ibmcloud fn package get --summary valhallaSamples
```
```bash
 package /namespace/valhallaSamples: Returns a result based on parameter place
      (parameters: *place)
    action /namespace/valhallaSamples/helloWorld: Demonstrates logging facilities
       (parameters: payload)
    action /namespace/valhallaSamples/greeting: Returns a friendly greeting
       (parameters: name, place)
    action /namespace/valhallaSamples/curl: Curl a host url
       (parameters: payload)
    action /namespace/valhallaSamples/wordCount: Count words in a string
       (parameters: payload)
```
Invoke an action in the package binding:
```bash
 ibmcloud fn action invoke --result valhallaSamples/greeting --param name Odin
 ```
 ```json
{
       "payload": "Hello, Odin from Valhalla!"
}
```
Invoke an action and overwrite the default parameter value:
```bash
ibmcloud fn action invoke --result valhallaSamples/greeting --param name Odin --param place Asgard
```
```json
{
       "payload": "Hello, Odin from Asgard!"
}
```
###### Create custom packages
Custom packages can be used to group your own actions, manage default parameters, and share entities with other users.
Create a package called custom:
```bash
ibmcloud fn package create custom
```
Get a summary of the package:
```bash
ibmcloud fn package get --summary custom
```
Create a file called identity.js that contains the following action code. This action returns all input parameters:
```js
function main(args) { return args; }
```
Create an identity action in the custom package
```bash
ibmcloud fn action create custom/identity identity.js
```
Get a summary of the package again:
```bash
ibmcloud fn package get --summary custom
```
```bash
 package /myNamespace/custom
      (parameters: none defined)
   action /myNamespace/custom/identity
      (parameters: none defined)
```
Invoke the action in the package:
```bash
ibmcloud fn action invoke --result custom/identity
```
```json
{}
```
###### Set default package parameters
You can set default parameters for all the entities in a package. You do this by setting package level parameters that are inherited by all actions in the package.
Update the custom package with two parameters: city and country:
```bash
ibmcloud fn package update custom --param city Austin --param country USA
```
Display the parameters in the package:
```bash
ibmcloud fn package get custom
```
Invoke the identity action without any parameters to verify that the action indeed inherits the parameters:
```bash
ibmcloud fn action invoke --result custom/identity
```
Invoke the identity action with a few parameters:
```bash
ibmcloud fn action invoke --result custom/identity --param city Dallas --param state Texas
```
Invocation parameters are merged with the package parameters. The invocation parameters override the package parameters.


###### Share packages
After the actions and feeds that comprise a package are debugged and tested, the package can be shared with all ICF users. Sharing the package makes it possible for the users to bind the package, invoke actions in the package, and author their own rules and sequence actions.
Share the package with all users:
```bash
ibmcloud fn package update custom --shared yes
```
Display the publish property of the package to verify that it is now true:
```bash
ibmcloud fn package get custom
```
Others can now use your custom package, including binding to the package or directly invoking an action in it. Other users must know the fully qualified names of the package to bind it or invoke actions in it. Actions and feeds within a shared package are public. If the package is private, then all of its contents are also private.
Get a description of the package to show the fully qualified names of the package and action:
```bash
ibmcloud fn package get --summary custom
```
```bash
package /myNamespace/custom: Returns a result based on parameters city and country
     (parameters: *city, *country)
   action /myNamespace/custom/identity
     (parameters: none defined)
```
###### Triggers

Triggers are a named channel for a class of events. The following are examples of triggers:

- A trigger of location update events
- A trigger of document uploads to a website
- A trigger of incoming emails
Triggers can be fired, or activated, by using a dictionary of key-value pairs. Sometimes this dictionary is referred to as the normalized, internal event. However, these normalized events are often a representation of raw data coming from external events generated outside the serverless platform. As with actions, each firing of a trigger results in an activation ID.

Triggers can be explicitly fired by a user or by an external event source. A feed is a convenient way to configure an external event source to fire trigger events that can be consumed by ICF. Examples of feeds include:

- CouchDB data change feed that fires a trigger event each time a document in a database is added or modified
- A Git feed that fires a trigger event for every commit to a Git repository

Instances of triggers can also be fired with parameters that can be passed on to one or more actions they can be connected to using rules.
 
###### Rules
A rule associates one trigger with one action. Every firing of the trigger causes the corresponding action to be invoked with the trigger event as input.

With the appropriate set of rules, it's possible for a single trigger event to invoke multiple actions, or for an action to be invoked as a response to events from multiple triggers.

Create triggers: 
You can create multiple rules that associate the same trigger with different actions.
```bash
ibmcloud fn trigger create locationUpdate
ibmcloud fn trigger list
ibmcloud fn trigger fire locationUpdate -p name "Barry" -p place "Central City"
ibmcloud fn trigger update locationUpdate -p name "Barry" -p place "Central City"
ibmcloud fn trigger get locationUpdate
ibmcloud fn action invoke --result hello --param name Oliver --param place "Starling City"
ibmcloud fn trigger get locationUpdate
## rule trigger action
ibmcloud fn rule create myRule locationUpdate hello
ibmcloud fn rule get myRule
## test rule
ibmcloud fn trigger fire locationUpdate --param name Kara --param place "Krypton"
ibmcloud fn activation list --limit 2
```

###### Connect trigger feeds
Trigger feeds allow you to connect triggers to external event sources. Event sources will fire registered triggers each time an event occurs. Here’s a list of the packages currently supported on IBM Cloud Functions (ICF) which include feeds to easily connect you to services like Slack, GitHub and IBM Watson.
```bash
ibmcloud fn package get --summary /whisk.system/alarms
ibmcloud fn action get --summary /whisk.system/alarms/interval
ibmcloud fn trigger create everyMinute --feed /whisk.system/alarms/interval -p minutes 1 -p trigger_payload "{\"name\":\"Mork\", \"place\":\"Ork\"}"
ibmcloud fn rule create everyMinuteRule everyMinute hello
ibmcloud fn activation poll
ibmcloud fn trigger delete everyMinute
ibmcloud fn rule delete everyMinuteRule
```
###### Web actions
Cloud Function actions can be annotated with a special flag, --web true, at creation to convert them into web actions. The result is the corresponding creation of a public URL that can be used to trigger the action from any web app.

Web actions can then be invoked via HTTP requests without user authentication where the HTTP request parameters are automatically converted in event parameters. Web actions are able to control the HTTP response headers and body to support any content types, manage cookies, and perform HTTP redirects directly.


- Invoke a web action from anywhere without defining a trigger or a rule
- Accessible through a REST interface without the need for credentials
- Supports any content-type on an HTTP response, including HTML, XML, SVG, PNG, and more, with intelligent defaults for JSON payloads
- Supports any type of HTTP method including GET, POST (the default), PUT, PATCH, and DELETE, as well as HEAD and OPTIONS

###### API Gateway
Cloud Functions comes with an integrated API Gateway service. This allows you to create new HTTP APIs which map incoming requests to actions.

The API Gateway handles capabilities like routing based on request properties (URI paths and HTTP method), user authentication, rate limiting, and more. You do not need to implement this feature within the web action code.
Web actions are actions that can be called externally using the HTTP protocol from clients like curl or web browsers. IBM Cloud Functions (ICF) provides a simple flag, --web true, which causes it to automatically create an HTTP accessible URL (endpoint) for any action.
```bash
ibmcloud fn action update hello --web true
ibmcloud fn action get hello --url
curl _abc_
```

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

###### Packages
- Group of actions together
- Set parameters used by all actions

###### Sequences
Invoke a set of actions in turn

``` 
    wsk property set --auth "$auth" --apihost https://192.168.0.104 -i
    wsk -i action list
    wsk -i action create helloJava main.jar --main Main --web true --docker openwhisk/java8action
    wsk action get --url helloJava

```



Sources:

Adventures in Apache Openwhisk - Rob Allen
Apache OpenWhisk: How it Works and How You Can Benefit - Carlos Santana, IBM
