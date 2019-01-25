//
//  WebViewController.swift
//  SNKit_TJS
//
//  Created by 郑军铎 on 2018/5/29.
//  Copyright © 2018年 syk. All rights reserved.
//

import UIKit
import RxSwift
import WebKit

open class WKWebViewController: BaseWebViewController<JDWKWebView>, WKNavigationDelegate {
    /// ZJaDe: 
    open var scriptMessageHandler: ScriptMessageHandler = ScriptMessageHandler() {
        didSet {
            self.resetScriptMessages()
        }
    }
    func resetScriptMessages() {
        self.removeAllUserScripts()
        self.scriptMessageHandler.addScriptMessages(in: self.rootView.configuration.userContentController)
    }
    func removeAllUserScripts() {
        self.rootView.configuration.userContentController.removeAllUserScripts()
    }
    /// ZJaDe: 
    let uiProxy: WKUIProxy = WKUIProxy()
    open override func viewDidLoad() {
        super.viewDidLoad()
        self.rootView.allowsBackForwardNavigationGestures = true
        self.rootView.uiDelegate = self.uiProxy
        self.rootView.navigationDelegate = self

    }
    // MARK: -
    open override func configWebView() {
        super.configWebView()
        resetScriptMessages()
    }
    deinit {
        removeAllUserScripts()
    }

    // MARK: - WKNavigationDelegate
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {

    }
    public var decidePolicyClosure: ((_ navigationAction: WKNavigationAction, _ decisionHandler: @escaping (WKNavigationActionPolicy)-> Void)->Void)?
    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let closure = self.decidePolicyClosure {
            closure(navigationAction, decisionHandler)
        } else {
            decisionHandler(.allow)
        }
    }
}
