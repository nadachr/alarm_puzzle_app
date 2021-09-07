package main

import (
	"fmt"
	"net/http"

	mqtt "github.com/eclipse/paho.mqtt.golang"
	"github.com/gin-gonic/gin"
)

var dataPayload string

var messagePubHandler mqtt.MessageHandler = func(client mqtt.Client, msg mqtt.Message) {
	fmt.Printf("Received message: %s from topic: %s\n", msg.Payload(), msg.Topic())
	dataPayload = string(msg.Payload())
}

var connectHandler mqtt.OnConnectHandler = func(client mqtt.Client) {
	fmt.Println("Connected")
}

var connectLostHandler mqtt.ConnectionLostHandler = func(client mqtt.Client, err error) {
	fmt.Printf("Connect lost: %v", err)
}

func main() {
	var broker = "192.168.137.1"
	var port = 1883
	opts := mqtt.NewClientOptions()
	opts.AddBroker(fmt.Sprintf("tcp://%s:%d", broker, port))
	opts.SetClientID("go_mqtt_client")
	opts.SetUsername("")
	opts.SetPassword("")
	opts.SetDefaultPublishHandler(messagePubHandler)
	opts.OnConnect = connectHandler
	opts.OnConnectionLost = connectLostHandler
	client := mqtt.NewClient(opts)
	if token := client.Connect(); token.Wait() && token.Error() != nil {
		panic(token.Error())
	}
	sub(client)

	router := gin.Default()
	router.GET("/alarm/:alarm", func(c *gin.Context) {
		alarm := c.Param("alarm")
		token := client.Publish("alarm", 0, false, alarm)
		token.Wait()
		c.IndentedJSON(http.StatusOK, gin.H{"message": "OK"})
	})

	router.Run("localhost:8080")

	client.Disconnect(250)
}

func sub(client mqtt.Client) {
	topic := "alarm"
	token := client.Subscribe(topic, 1, nil)
	token.Wait()
	fmt.Printf("Subscribed to topic: %s", topic)
}

// func getAlarmOff(c *gin.Context) {
// 	alarm := c.Param("alarm")
// 	if alarm == "1" {
// 		c.IndentedJSON(http.StatusOK, "Alarm is off")
// 		alarmStatus = alarm
// 		return
// 	}
// 	c.IndentedJSON(http.StatusNotFound, gin.H{"message": alarmStatus})
// }

// func publish(client mqtt.Client) {
// 	// num := 10
// 	// for i := 0; i < num; i++ {
// 	// text := fmt.Sprintf("Message %d", i)
// 	token := client.Publish("alarm", 0, false, alarmStatus)
// 	token.Wait()
// 	// time.Sleep(time.Second)
// 	// }
// }

