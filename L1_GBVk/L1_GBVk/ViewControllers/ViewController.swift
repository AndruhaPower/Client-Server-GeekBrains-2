//
//  ViewController.swift
//  L1_GBVk
//
//  Created by Andrew on 16/05/2019.
//  Copyright © 2019 Andrew. All rights reserved.
//
import Foundation
import UIKit
import WebKit
import SwiftKeychainWrapper

class ViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var logoImageView: LogoImageView!
    @IBOutlet private weak var usernameLabel: UILabel!
    @IBOutlet private weak var usernameTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var scrollView: UIScrollView!
    private var timerSeconds = 2
    @IBOutlet private weak var VKwebView: WKWebView! {
        didSet{
            VKwebView.navigationDelegate = self
        }
    }
    // MARK: - Actions
    
    @IBAction func unwindSegue(segue: UIStoryboardSegue) {}
    @IBAction func loginButtonPress(_ sender: UIButton) {
        checkLogin()
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let hideKeyboardGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        scrollView?.addGestureRecognizer(hideKeyboardGesture)
        logoImageView.image = UIImage(named: "logo")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewDidAppearConfig()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.viewWillDissapearConfig()
    }
    
    // MARK: - Вспомогательные функции
    
    // Функции клавиатуры
    
    @objc private func keyboardWasShown(notification: Notification) {
        let info = notification.userInfo! as NSDictionary
        let kbSize = (info.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue).cgRectValue.size
        
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: kbSize.height, right: 0)
        
        self.scrollView?.contentInset = contentInsets
        scrollView?.scrollIndicatorInsets = contentInsets
    }
    
    @objc private func keyboardWillBeHidden(notification: Notification) {
        let contentInsets = UIEdgeInsets.zero
        scrollView?.contentInset = contentInsets
        scrollView?.scrollIndicatorInsets = contentInsets
    }
    
    @objc private func hideKeyboard() {
        self.scrollView.endEditing(true)
    }
    
    // Функции вспомогательные собственно
    
    private func logoutVK() {
        let dataSource = WKWebsiteDataStore.default()
        dataSource.fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            dataSource.removeData(
                ofTypes: WKWebsiteDataStore.allWebsiteDataTypes(),
                for: records.filter { $0.displayName.contains("vk") },
                completionHandler: { }
            )
        }
    }
    
    private func checkLogin() {
        if usernameTextField.text == "" && passwordTextField.text == "" {
            performSegue(withIdentifier: "goToMainTabbar", sender: nil)
        }else{
            let alert = UIAlertController(title: "ERROR!", message: "Incorrect Password or Login", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default) { _ in
                self.passwordTextField.text = ""
            }
            alert.addAction(action)
            present(alert, animated: true)
        }
    }
    
    private func viewDidAppearConfig() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWasShown(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillBeHidden(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        view.alpha = 0.5
        let loadingCirclesImage = LoadingCirclesImage(frame: CGRect(x: 0, y:0, width: view.bounds.width, height: view.bounds.height))
        view.addSubview(loadingCirclesImage)
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            self.timerSeconds -= 1
            if self.timerSeconds == 0 {
                timer.invalidate()
                loadingCirclesImage.removeFromSuperview()
                self.view.alpha = 1
            }
        }
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "oauth.vk.com"
        urlComponents.path = "/authorize"
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: "7042441"),
            URLQueryItem(name: "display", value: "mobile"),
            URLQueryItem(name: "redirect_uri", value: "https://oauth.vk.com/blank.html"),
            URLQueryItem(name: "scope", value: "262150"),
            URLQueryItem(name: "response_type", value: "token"),
            URLQueryItem(name: "v", value: "5.68")
        ]
        let request = URLRequest(url: urlComponents.url!)
        self.VKwebView.load(request)
    }
    
    private func viewWillDissapearConfig() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}

extension ViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        
        guard let url = navigationResponse.response.url, url.path == "/blank.html", let fragment = url.fragment  else {
            decisionHandler(.allow)
            return
        }
        
        let params = fragment
            .components(separatedBy: "&")
            .map { $0.components(separatedBy: "=") }
            .reduce([String: String]()) { result, param in
                var dict = result
                let key = param[0]
                let value = param[1]
                dict[key] = value
                return dict
        }
        
        let token = params["access_token"]
        guard let unwrappedToken = token else { return }
        
        KeychainWrapper.standard.set(unwrappedToken, forKey: "VKToken")
        print(KeychainWrapper.standard.string(forKey: "VKToken")!)
        
        self.performSegue(withIdentifier: "goToMainTabbar", sender: self)
        
        decisionHandler(.cancel)
    }
}
