//
//  PDFPreviewVC.swift
//  PDFGenerator
//
//  Created by Suguru Kishimoto on 2016/02/06.
//
//

import Foundation
import UIKit


class PDFPreviewVC: UIViewController {
    
    @IBOutlet private weak var webView: UIWebView!
    var url: URL!
    override func viewDidLoad() {
        super.viewDidLoad()
        var req = URLRequest(url: url)
        req.timeoutInterval = 60.0
        req.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData

        webView.scalesPageToFit = true
        webView.loadRequest(req)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc @IBAction private func close(_ sender: AnyObject!) {
        dismiss(animated: true, completion: nil)
    }
    
    func setupWithURL(_ url: URL) {
        self.url = url
    }

}
