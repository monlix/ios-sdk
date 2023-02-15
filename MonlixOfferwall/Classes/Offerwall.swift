import UIKit
import WebKit

public enum MonlixGender {
    case MALE
    case FEMALE
    case OTHER
}

public struct MonlixConfig {
    let appId: String
    let userId: String
    let subId: String?
    let age: Int?
    let gender: MonlixGender?
    let zoneId: String?
    
    public init(appId: String, userId: String, subId: String? = nil, age: Int? = nil, gender: MonlixGender? = nil, zoneId: String? = nil) {
        self.appId = appId
        self.userId = userId
        self.subId = subId
        self.age = age
        self.gender = gender
        self.zoneId = zoneId
    }
}

private let CLOSE_ACTION_STR = "close-app"
private let PRIVACY_POLICY_URL = "https://monlix.com/privacy-policy"
private let TERMS_URL = "https://monlix.com/terms-and-conditions"
private let TERMS_ACCEPTED_KEY = "MONLIX_TERMS_ACCEPTED"

class PrivacyGesture: UITapGestureRecognizer {
    var url = String()
}

private let OBJC_MALE: NSNumber = 0
private let OBJC_FEMALE: NSNumber = 1
private let OBJC_OTHER: NSNumber = 2

public class MonlixOfferwall: UIViewController, WKUIDelegate, WKNavigationDelegate {
    
    private var apiUrl = "https://offers.monlix.com"
    private lazy var webView: WKWebView = {
        let webConfiguration = WKWebViewConfiguration()
        let webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()
    
  
    @objc public func initObjC(appId: String, userId: String, subId: String? = nil, age: NSNumber? = nil, gender: NSNumber? = nil, zoneId: NSNumber? = nil  ) -> Any {
        
        apiUrl += "?appid=\(appId)"
        apiUrl += "&userid=\(userId)"
        if(subId != nil) {
            apiUrl += "&subid=\(subId!)"
        }
        if(age != nil)  {
            apiUrl += "&age=\(age!)"
        }
        if(gender != nil) {
            var genderStr = ""
            switch (gender) {
            case OBJC_MALE:
                genderStr = "MALE";
            case OBJC_FEMALE:
                genderStr = "FEMALE";
            case OBJC_OTHER:
                genderStr = "OBJC_OTHER";
            case .none:
                genderStr = "OTHER"
            case .some(_):
                genderStr = "OTHER"
            }
            print(genderStr)
            apiUrl += "&gender=\(genderStr)"
        }
        if(zoneId != nil) {
            apiUrl += "&zoneid=\(zoneId!)"
        }
        apiUrl += "&mobile=true"
        
        return true
    }
    
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
    }
    
    public init(config: MonlixConfig) {
        apiUrl += "?appid=\(config.appId)"
        apiUrl += "&userid=\(config.userId)"
        if(config.subId != nil) {
            apiUrl += "&subid=\(config.subId!)"
        }
        if(config.age != nil)  {
            apiUrl += "&age=\(config.age!)"
        }
        if(config.gender != nil) {
            apiUrl += "&gender=\(config.gender!)"
        }
        if(config.zoneId != nil) {
            apiUrl += "&zoneid=\(config.zoneId!)"
        }
        apiUrl += "&mobile=true"
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        let myURL = URL(string: apiUrl)
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
    }
    
    @objc func labelClicked(_ sender: PrivacyGesture) {
        UIApplication.shared.open(URL(string: sender.url)!)
    }
    
    private func createLabel(text: String, link: String? = nil, bold: Bool? = false) -> UILabel {
        let label = UILabel()
        label.text  = text
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont.systemFont(ofSize: 14)
        label.sizeToFit()
        label.numberOfLines = 0
        if(bold == true) {
            label.font = UIFont.boldSystemFont(ofSize: 14)
            if #available(iOS 13.0, *) {
                label.textColor = UIColor.link
            } else {
                label.textColor = UIColor.blue
            }
        }
        
        if(link != nil) {
            label.isUserInteractionEnabled = true

            let tap = PrivacyGesture(target: self, action: #selector(labelClicked(_:)))
            tap.url = link!
            label.addGestureRecognizer(tap)
        }
        
        return label
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        if(UserDefaults.standard.bool(forKey: TERMS_ACCEPTED_KEY) == false) {
            showTermsAlert()
        }
    }
    
    private func showTermsAlert() {
        
        let alertController = UIAlertController(title: "\n\n\n\n\n\n", message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        
        let headerTextLabel = createLabel(text: "To continue using the app, you must consent with the privacy policy and terms and conditions:")
        let privacyLabel = createLabel(text: "1.  Privacy policy Link", link: PRIVACY_POLICY_URL, bold: true)
        let termsLabel = createLabel(text: "2. Terms & Conditions Link", link: TERMS_URL, bold: true)
   
        let stackView   = UIStackView()
        stackView.axis  = NSLayoutConstraint.Axis.vertical
        stackView.distribution  = UIStackView.Distribution.fill
        stackView.alignment = UIStackView.Alignment.fill
        stackView.spacing  = 16.0
        stackView.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 32)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        stackView.addArrangedSubview(headerTextLabel)
        stackView.addArrangedSubview(privacyLabel)
        stackView.addArrangedSubview(termsLabel)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.widthAnchor.constraint(equalToConstant: alertController.view.bounds.width).isActive = true

        alertController.view.addSubview(stackView)
        
        
        let agreeAction = UIAlertAction(title: "I agree to terms and conditions", style: .default, handler: {(alert: UIAlertAction!) in
            UserDefaults.standard.set(true, forKey: TERMS_ACCEPTED_KEY)
            alertController.dismiss(animated: true)
        })

        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: {(alert: UIAlertAction!) in
            UserDefaults.standard.set(false, forKey: TERMS_ACCEPTED_KEY)
            alertController.dismiss(animated: true)
            self.dismiss(animated: true)
        })

        alertController.addAction(agreeAction)
        alertController.addAction(cancelAction)

        self.present(alertController, animated: true, completion:{})
    }
    
    private func setupUI() {
        self.view.backgroundColor = .white
        self.view.addSubview(webView)
        
        if #available(iOS 11.0, *) {
            NSLayoutConstraint.activate([
                webView.topAnchor
                    .constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
                webView.leftAnchor
                    .constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor),
                webView.bottomAnchor
                    .constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
                webView.rightAnchor
                    .constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor)
            ])
        } else {
            NSLayoutConstraint.activate([
                webView.topAnchor
                    .constraint(equalTo: self.view.layoutMarginsGuide.topAnchor),
                webView.leftAnchor
                    .constraint(equalTo: self.view.layoutMarginsGuide.leftAnchor),
                webView.bottomAnchor
                    .constraint(equalTo: self.view.layoutMarginsGuide.bottomAnchor),
                webView.rightAnchor
                    .constraint(equalTo: self.view.layoutMarginsGuide.rightAnchor)
            ])
        }
    }
    
    private var isInitialLoad = true
    
    
    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        print(navigationAction)
        if(navigationAction.request.url?.lastPathComponent == CLOSE_ACTION_STR) {
            decisionHandler(.cancel)
            dismiss(animated: true)
            return
        }
        decisionHandler(isInitialLoad ? .allow : .cancel)
        if(!isInitialLoad) {
            UIApplication.shared.open(URL(string: navigationAction.request.url!.absoluteString)!)
        }
        if(isInitialLoad) {
            isInitialLoad = false
        }
    }
}
