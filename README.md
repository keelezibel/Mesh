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
com.test.mesh2
