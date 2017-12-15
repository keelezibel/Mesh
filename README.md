# Ionic

## Setup Ionic
- Download Node.js
```shell
npm install -g cordova ionic
```

## Start a new Ionic App
```shell
ionic start myApp
```

## Run App
```shell
cd myApp
ionic serve
```

## Generate a new page
```shell
ionic g page newPage
```

## Download map tiles for offline use

## Deploy for iOS
```shell
$ xcode-select --install
$ npm install -g ios-deploy OR sudo npm install --global --unsafe-perm ios-deploy
$ ionic cordova build ios --prod
$ open ./platforms/ios/MyApp.xcworkspace/
```

# Bridgefy
## Change API key for Bridgefy
```swift
self.transmitter = BFTransmitter(apiKey: "API KEY")
```

## Bundle identifier
com.test.mesh3

## Note about Bridgefy
Broadcast messages are restricted to be sent using mesh network, so can't send binary file using broadcast mode. Possible to add into dictionary but will be rejected if h3

## Note about Bridgefy
- Broadcast messages are restricted to be sent using mesh network, so can't send binary file using broadcast mode. Possible to add into dictionary but will be rejected if >2048 bytes.
- Image data can be sent using 'withData:' argument.
- Binary files restricted to enter mesh network so as not to affect performance of mesh network.
- iOS framework uses Wifi Peer-to-Peer and BLE. Connection between iOS devices use Wifi Peer-to-Peer and can go up to 2Mbps. Connection between iOS and Android will be using BLE at most 45kbps. Size of binary file is restricted to 120kb in BLE.
