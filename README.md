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
## Change API key for Bridgefy iOS (ChatListController.m)
```swift
self.transmitter = BFTransmitter(apiKey: "API KEY")
```

## Change API key for Bridgefy Android (AndroidManifest.xml)
```
android:value="" />
```
## Change application bundle id (build.gradle)
```
defaultConfig { ... applicationId "com.test.mesh3" ... }
```

## Bundle identifier
com.test.mesh3

## Note about Bridgefy
- Broadcast messages are restricted to be sent using mesh network, so can't send binary file using broadcast mode. Possible to add into dictionary but will be rejected if >2048 bytes.
- Image data can be sent using 'withData:' argument.
- Binary files restricted to enter mesh network so as not to affect performance of mesh network.
- iOS framework uses Wifi Peer-to-Peer and BLE. Connection between iOS devices use Wifi Peer-to-Peer and can go up to 2Mbps. Connection between iOS and Android will be using BLE at most 45kbps. Size of binary file is restricted to 120kb in BLE.

## Remove large file in case committed wrongly
```
git filter-branch --index-filter 'git rm -r --cached --ignore-unmatch <file/dir>' HEAD
```
OR
```
git rm --cached path/to/your/big/file
git commit --amend -CHEAD
git push
```
## Find large files and add to .gitignore
```
find . -size +1G | cat >> .gitignore
```

## CartoDB
- URL: https://keelezibel.carto.com/me
- Mobile SDK guide: https://carto.com/docs/carto-engine/mobile-sdk/getting-started/
