package hello

import (
	"fmt"
	"net/http"
	"os"

	"github.com/apache/openwhisk-client-go/whisk"
	"github.com/sirupsen/logrus"
)

var log = logrus.New()

// Hello receive an event in format
// { "name": "Mike"}
// and returns a greeting in format
// { "greetings": "Hello, Mik e"}
func Hello(args map[string]interface{}) map[string]interface{} {
	log.Out = os.Stdout
	res := make(map[string]interface{})
	greetings := "world"
	name, ok := args["name"].(string)
	if ok {
		greetings = name
	}
	log.Printf("name = %s\n", name)
	//APIHOST=https://192.168.0.104
	//AUTH=23bc46b1-71f6-4ed5-8c54-816aa4f8c502:123zO3xZCLrMN6v2BKK1dXYFpXlPkccOFqm12CdAsMgRU4VrNZ9lyGVCGuMDGIwP

	config := &whisk.Config{
		Host:      "https://192.168.0.104",
		Version:   "v1",
		Namespace: "guest",
		// Key:       "23bc46b1-71f6-4ed5-8c54-816aa4f8c502:123zO3xZCLrMN6v2BKK1dXYFpXlPkccOFqm12CdAsMgRU4VrNZ9lyGVCGuMDGIwP",
		Insecure: true,
	}

	// client, er := whisk.Newclient(http.DefaultClient, config)

	// if er != nil {
	// 	fmt.Println(er)
	// 	os.Exit(-1)
	// }

	// options := &whisk.ActionListOptions{
	// 	Limit: 30,
	// 	Skip:  30,
	// }

	// actions, resp, err := client.Actions.List(options)
	// if err != nil {
	// 	fmt.Println(err)
	// 	os.Exit(-1)
	// }

	// fmt.Printf("error %v\n", err)
	fmt.Printf("OPENWHISK_HOME = %s\n", os.Getenv("OPENWHISK_HOME"))
	fmt.Printf("HOME = %s\n", os.Getenv("HOME"))
	client, err := whisk.NewClient(http.DefaultClient, config)
	if err != nil {
		fmt.Println(err)
		os.Exit(-1)
	}

	// options := &whisk.ActionListOptions{
	// 	Limit: 30,
	// 	Skip:  30,
	// }

	actions, resp, err := client.Actions.List("", nil)
	if err != nil {
		fmt.Println(err)
		res["result"] = "Actions.List error"
		return res
	}
	fmt.Println(actions)
	fmt.Println(resp)

	res["result"] = "result" + greetings
	log.WithFields(logrus.Fields{"greetings": greetings}).Info("Hello")
	return res
}

func main() {

}
