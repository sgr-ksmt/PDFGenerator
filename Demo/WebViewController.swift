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

    @IBOutlet private weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let req = NSMutableURLRequest(URL: NSURL(string: "http://www.yahoo.co.jp")!, cachePolicy: .ReloadIgnoringCacheData, timeoutInterval: 60)
        webView.loadRequest(req)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func generatePDF() {
        do {
            let dst = NSHomeDirectory().stringByAppendingString("/sample_tblview.pdf")
            try PDFGenerator.generate(webView, outputPath: dst)
            openPDFViewer(dst)
        } catch let error {
            print(error)
        }
        
    }

    private func openPDFViewer(pdfPath: String) {
        let url = NSURL(fileURLWithPath: pdfPath)
        let storyboard = UIStoryboard(name: "PDFPreviewVC", bundle: nil)
        let vc = storyboard.instantiateInitialViewController() as! PDFPreviewVC
        vc.setupWithURL(url)
        presentViewController(vc, animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
