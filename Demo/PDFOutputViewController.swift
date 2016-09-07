//
//  PDFOutputViewController.swift
//  PDFGenerator
//
//  Created by Suguru Kishimoto on 9/7/16.
//
//

import UIKit
import PDFGenerator

class PDFOutputViewController: UIViewController {

    @IBOutlet private weak var scrollView: UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func render(_: UIButton) {
        let dst = NSHomeDirectory().stringByAppendingString("/test.pdf")
        try! PDFGenerator.generate(self.scrollView, outputPath: dst)
        openPDFViewer(dst)
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
