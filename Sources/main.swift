import PerfectLib
import PerfectHTTP
import PerfectHTTPServer
import PerfectNotifications

// your app id. we use this as the configuration name, but they do not have to match
let notificationsAppId = "com.arcyn1c.dropp"

let apnsKeyIdentifier = "Z2H285X72A"
let apnsTeamIdentifier = "ZR82Q7TH8E"
let apnsPrivateKeyFilePath = "/Users/jeffery/Documents/Developer/Projects/Thumb Taps/Dropp/Server/APNsAuthKey_Z2H285X72A.p8"

// An example request handler.
// This 'handler' function can be referenced directly in the configuration below.
func handler(data: [String:Any]) throws -> RequestHandler {
	return {
		request, response in
		// Respond with a simple message.
		response.setHeader(.contentType, value: "text/html")
		response.appendBody(string: "<html><title>Hello, world!</title><body>Hello, world!</body></html>")
		// Ensure that response.completed() is called when your processing is done.
		response.completed()
	}
}

// Configuration data for two example servers.
// This example configuration shows how to launch one or more servers
// using a configuration dictionary.

let port1 = 8080, port2 = 8181

let confData = [
	"servers": [
		// Configuration data for one server which:
		//	* Serves the hello world message at <host>:<port>/
		//	* Serves static files out of the "./webroot"
		//		directory (which must be located in the current working directory).
		//	* Performs content compression on outgoing data when appropriate.
		[
			"name":"localhost",
			"port":port1,
			"routes":[
				["method":"get", "uri":"/", "handler":handler],
				["method":"get", "uri":"/**", "handler":PerfectHTTPServer.HTTPHandler.staticFiles,
				 "documentRoot":"./webroot",
				 "allowResponseFilters":true]
			]
		],
		// Configuration data for another server which:
		//	* Redirects all traffic back to the first server.
		[
			"name":"localhost",
			"port":port2,
			"routes":[
				["method":"get", "uri":"/**", "handler":PerfectHTTPServer.HTTPHandler.redirect,
				 "base":"http://localhost:\(port1)"]
			]
		]
	]
]

do {
	NotificationPusher.addConfigurationAPNS(
		name: notificationsAppId,
		production: false, // should be false when running pre-release app in debugger
		keyId: apnsKeyIdentifier,
		teamId: apnsTeamIdentifier,
		privateKeyPath: apnsPrivateKeyFilePath)
	
	
	let deviceIds: [String] = ["9212D37410BBC8E9FD9416F6189FCD27B8AFF7792092C1DB2510E0FB9DCEE49E"]
	let n = NotificationPusher(apnsTopic: notificationsAppId)
	
	n.pushAPNS(
		configurationName: notificationsAppId,
		deviceTokens: deviceIds,
		notificationItems: [.alertTitle("Dropp"), .alertBody("Hello!"), .sound("default")]) {
			responses in
			print("\(responses)")
	}
	
	// Launch the servers based on the configuration data.
	try HTTPServer.launch(configurationData: confData)
	
} catch {
	fatalError("\(error)") // fatal error launching one of the servers
}
