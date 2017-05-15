import PackageDescription

let package = Package(
	name: "Dropp-Server",
	dependencies: [
		.Package(url: "https://github.com/PerfectlySoft/Perfect-HTTP.git", majorVersion: 2),
		.Package(url: "https://github.com/PerfectlySoft/Perfect-HTTPServer.git", majorVersion: 2),
		.Package(url:"https://github.com/PerfectlySoft/Perfect-MongoDB.git", majorVersion: 2, minor: 0),
		.Package(url: "https://github.com/PerfectlySoft/Perfect-Notifications.git", majorVersion: 2)
	]
)
