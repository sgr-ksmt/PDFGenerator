//
//  PDFPreviewVC.swift
//  PDFGenerator
//
//  Created by Suguru Kishimoto on 2016/02/06.
//
//

import UIKit
import WebKit

class PDFPreviewVC: UIViewController {

    @IBOutlet fileprivate weak var webView: WKWebView!
    var url: URL!
    override func viewDidLoad() {
        super.viewDidLoad()
        let req = NSMutableURLRequest(url: url)
        req.timeoutInterval = 60.0
        req.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData

        // webView.scalesPageToFit = true
        webView.load(req as URLRequest)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction fileprivate func close(_ sender: AnyObject!) {
        dismiss(animated: true, completion: nil)
    }

    func setupWithURL(_ url: URL) {
        self.url = url
    }
}
