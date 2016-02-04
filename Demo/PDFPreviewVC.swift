
//
//  PDFPreviewVC.swift
//  PDFGenerator
//
//  Created by Suguru Kishimoto on 2016/02/06.
//
//

import UIKit


class PDFPreviewVC: UIViewController {
    
    @IBOutlet private weak var webView: UIWebView!
    var url :NSURL!
    override func viewDidLoad() {
        super.viewDidLoad()
        let req = NSMutableURLRequest(URL: url)
        req.timeoutInterval = 60.0
        req.cachePolicy = .ReloadIgnoringLocalAndRemoteCacheData

        webView.scalesPageToFit = true
        webView.loadRequest(req)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc @IBAction private func close(sender: AnyObject!) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func setupWithURL(url: NSURL) {
        self.url = url
    }

}
