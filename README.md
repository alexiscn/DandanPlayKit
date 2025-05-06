# DandanPlayKit
Swift client library for dandanplay

# How to use

- Apply the AppId and AppSecret [here](https://doc.dandanplay.com/open/#%E4%BA%8C%E3%80%81api-%E6%8E%A5%E5%85%A5%E6%8C%87%E5%8D%97)
- Create instance of `DandanPlayClient`
- Call method of `DandanPlayClient`


```swift

import DandanPlayKit

class DandanPlayService {

    static let shared = DandanPlayService()

    private let client = DandanPlayClient(appID: "you_app_id", appSecret: "your_app_secret")

    private init() {
        
    }

}

```
