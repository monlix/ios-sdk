# MonlixOfferwall

## Installation

MonlixOfferwall is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'MonlixOfferwall', '~> 0.0.2'
```

## Storyboard Usage

**Import the library**
```ruby
import MonlixOfferwall
```

**Init the library**
```ruby
let vc = MonlixOfferwall(config: MonlixConfig(appId: "74c6f10c7a5c5088dcecbf0ee0e44b4b",userId: "6"))
vc.modalPresentationStyle = .fullScreen
self.present(vc, animated: true)
```

## SwiftUI Usage
**Import the library**
```ruby
import MonlixOfferwall
```

**Create UIViewControllerRepresentable View**
```ruby
struct MyView: UIViewControllerRepresentable {
    typealias UIViewControllerType = MonlixOfferwall
    
    func makeUIViewController(context: Context) -> MonlixOfferwall {
        let vc = MonlixOfferwall(config: MonlixConfig(appId: "9109486b4386234b1b9ccfddefb6610e", userId: "1"))
        return vc
    }
    
    func updateUIViewController(_ uiViewController: MonlixOfferwall, context: Context) {}
}
```

**Attach to ContentView**

```ruby
struct ContentView: View {
    @State var isPresented = false
    
    var body: some View {
        VStack {
            Button("Show offerwall", action: {isPresented = true})
        }
        .padding()
        .sheet(isPresented: $isPresented) {
                    MyView()
         }
    }
}
```

## Objective-C Usage
**Import the library**
```ruby
#import "MonlixOfferwall-Swift.h"
```

**Init the library**
```ruby
  MonlixOfferwall *offerwall = [[MonlixOfferwall alloc] init];
  [offerwall initObjCWithAppId:@"74c6f10c7a5c5088dcecbf0ee0e44b4b" userId:@"6" subId:nil age:nil gender:@3 zoneId:nil]; 
  [self presentViewController:offerwall animated:YES completion:nil];
```
**Gender values:**
 0 - Male
 1 - Female
 2 - Other


## License

MonlixOfferwall is available under the MIT license. See the LICENSE file for more info.
