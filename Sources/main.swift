import PerfectLib
import PerfectHTTP
import PerfectHTTPServer
import MongoDB
import PerfectNotifications

// your app id. we use this as the configuration name, but they do not have to match
let notificationsAppId = "com.arcyn1c.dropp"

let apnsKeyIdentifier = "Z2H285X72A"
let apnsTeamIdentifier = "ZR82Q7TH8E"
let apnsPrivateKeyFilePath = "APNsAuthKey_Z2H285X72A.p8"

// An example request handler.
// This 'handler' function can be referenced directly in the configuration below.
func homeRoute(data: [String:Any]) throws -> RequestHandler {
	return { request, response in
		// Respond with a simple message.
		response.setHeader(.contentType, value: "text/html")
		response.appendBody(string: "<html><title>Hello, world!</title><body>Hello, world!</body></html>")
		// Ensure that response.completed() is called when your processing is done.
		print("Well now")
		response.completed()
	}
}
func APNSRegister(data: [String:Any]) throws -> RequestHandler {
	return { request, response in
		response.setHeader(.contentType, value: "text/html")
		response.appendBody(string: "<html><title>Hello, world!</title><body>Hello, world!</body></html>")

		print("Request: ", request)
		response.completed()
	}
}

let port = 80

let confData = [
	"servers": [
		[
			"name": "localhost",
			"port": port,
			"routes": [
				// home
				[
					"method": "get",
					"uri": "/",
					"handler": homeRoute
				],
				
//				// catch-all for static files
//				[
//					"method": "get",
//					"uri": "/**",
//					"handler": PerfectHTTPServer.HTTPHandler.staticFiles,
//					"documentRoot": "/",
//					"allowResponseFilters": true
//				],
				
				// APNS device registration
				[
					"method": "post",
					"uri": "/apns-register",
					"handler": APNSRegister
				]
				
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
