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

    @IBOutlet fileprivate weak var scrollView: UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func render(_: UIButton) {
        let dst = NSHomeDirectory() + "/test.pdf"
        try! PDFGenerator.generate(self.scrollView, to: dst)
        openPDFViewer(dst)
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
