//
//  WebViewController.swift
//  PDFGenerator
//
//  Created by Suguru Kishimoto on 2016/03/23.
//
//

import UIKit
import WebKit
import PDFGenerator

class WebViewController: UIViewController {

    @IBOutlet fileprivate weak var webView: WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        let req = NSMutableURLRequest(url: URL(string: "http://www.yahoo.co.jp")!, cachePolicy: .reloadIgnoringCacheData, timeoutInterval: 60)
        webView.load(req as URLRequest)
    }

    @IBAction func generatePDF() {
        do {
            let dst = NSHomeDirectory() + "/sample_tblview.pdf"
            try PDFGenerator.generate(webView, to: dst)
            openPDFViewer(dst)
        } catch let error {
            print(error)
        }

    }

    fileprivate func openPDFViewer(_ pdfPath: String) {
        self.performSegue(withIdentifier: "PreviewVC", sender: pdfPath)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let pdfPreviewVC = segue.destination as? PDFPreviewVC, let pdfPath = sender as? String {
            let url = URL(fileURLWithPath: pdfPath)
            pdfPreviewVC.setupWithURL(url)
        }
    }
}
