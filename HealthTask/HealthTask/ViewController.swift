//
//  ViewController.swift
//  HealthTask
//
//  Created by trioangle on 29/10/22.
//

import UIKit
import WebKit

class ViewController: UIViewController {

    @IBOutlet weak var splashImg: UIImageView!
    @IBOutlet weak var webView: WKWebView!
    
    var url = "https://www.75health.com"
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let request = URLRequest(url: URL(string: url)!)
        webView?.load(request)
        webView?.navigationDelegate = self
        webView?.uiDelegate = self
        self.splashImg.isHidden = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.homeTapped), name:Notification.Name(rawValue: "home"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.calendarTapped), name:Notification.Name(rawValue: "calendar"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.historyTapped), name:Notification.Name(rawValue: "history"), object: nil)
    }
    
    @objc
    func homeTapped() {
        self.homeX()
    }
    
    @objc
    func calendarTapped() {
        self.calendarX()
    }
    
    @objc
    func historyTapped() {
        self.historyX()
    }
    
    private
    func setNaviagationButton() {
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "homekit"),
                            style: .done,
                            target: self,
                            action: #selector(homeX)),
            
            UIBarButtonItem(image: UIImage(systemName: "calendar"),
                            style: .done,
                            target: self,
                            action: #selector(calendarX)),
            
            UIBarButtonItem(image: UIImage(systemName: "person.fill"),
                            style: .done,
                            target: self,
                            action: #selector(historyX))
        ]
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "line.3.horizontal.decrease"),
                                                           style: .done,
                                                           target: self,
                                                           action: #selector(menuX))
    }
    
    @objc func calendarX() {
        webView.evaluateJavaScript("Health.calendar()") { (res,err) in
            print("Got it")
        }
    }
    @objc func historyX() {
        webView.evaluateJavaScript("patient.history()") { (res,err) in
            print("Got it")
        }
    }
    @objc func homeX() {
        webView.evaluateJavaScript("Health.goBackHome()") { (res,err) in
            print("Got it")
        }
    }
    @objc func menuX() {
        let storyboard = UIStoryboard.init(name: "Health", bundle: nil)
        let menuVc = storyboard.instantiateViewController(withIdentifier: "NewVC") as! NewVC
        menuVc.modalPresentationStyle = .overCurrentContext
        self.present(menuVc, animated: false, completion: nil)
    }

    func loadData(link : String) {
        let url = URL(string: link)!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
        
    }
}

extension ViewController: WKNavigationDelegate,WKUIDelegate {
    
    public func webView(_ webView: WKWebView,
                        decidePolicyFor navigationAction: WKNavigationAction,
                        decisionHandler: @escaping (WKNavigationActionPolicy) -> Swift.Void) {

        print("*********************************************************navigationAction load:\(String(describing: navigationAction.request.url))")
        let str = String(describing: navigationAction.request.url)
        if str.contains("/challenge/complete"){
           
        }
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView,didStartProvisionalNavigation navigation: WKNavigation!) {
        print("start load:\(String(describing: webView.url))")
        splashImg.isHidden = false
        if webView.url!.description.contains("kp") {
           print("Action bar is hidden")
        } else {
            self.setNaviagationButton()
        }
    }
    
    func webView(_ webView: WKWebView,
                 didFail navigation: WKNavigation!,
                 withError error: Error) {
        print("fail with error: \(error.localizedDescription)")
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            print("finish loading")
            splashImg.isHidden = true
            self.setNaviagationButton()
            webView.evaluateJavaScript("myFunction()", completionHandler: { result, error in
            print(result)
            print("didFinish")
        })
        
    }
    func convertStringToDictionary(text: String) -> [String:AnyObject]? {
        if let data = text.data(using: String.Encoding.utf8) {
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:AnyObject]
                return json
            } catch {
                print("Something went wrong")
            }
        }
        return nil
    }
}
