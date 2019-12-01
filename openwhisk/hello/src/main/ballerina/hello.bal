import ballerina/io;

public function main(json jsonInput) returns  json? {
  io:println(jsonInput);
  json output = { "response": "hello-world"};
  return output;
}