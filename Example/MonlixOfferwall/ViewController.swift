import UIKit
import MonlixOfferwall

class ViewController: UIViewController {

    @IBAction func showOfferwall(_ sender: Any) {
        let config = MonlixConfig(appId: "74c6f10c7a5c5088dcecbf0ee0e44b4b", userId: "123")
        let vc = MonlixOfferwall(config: config)
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

