//
//  ViewController.swift
//  Demo
//
//  Created by Suguru Kishimoto on 2016/02/04.
//
//

import UIKit
import PDFGenerator

class ViewController: UIViewController {
    
    private var outputAsData: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func getImagePath(number: Int) -> String {
        return NSBundle.mainBundle().pathForResource("sample_\(number)", ofType: "jpg")!
    }
    
    private func getDestinationPath(number: Int) -> String {
        return NSHomeDirectory().stringByAppendingString("/sample\(number).pdf")
    }
    
    @objc @IBAction private func generateSamplePDFFromViews(sender: AnyObject?) {
        let v1 = UIScrollView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        let v2 = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 200))
        let v3 = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 200))
        v1.backgroundColor = UIColor.redColor()
        v1.contentSize = CGSize(width: 100, height: 100)
        v2.backgroundColor = UIColor.greenColor()
        v3.backgroundColor = UIColor.blueColor()
        
        do {
            let dst = getDestinationPath(1)
            if outputAsData {
                let data = try PDFGenerator.generate([v1, v2, v3])
                data.writeToFile(dst, atomically: true)
            } else {
                try PDFGenerator.generate([v1, v2, v3], outputPath: dst)
            }
            openPDFViewer(dst)
        } catch (let e) {
            print(e)
        }
    }
    
    @objc @IBAction private func generateSamplePDFFromImages(sender: AnyObject?) {
        let dst = getDestinationPath(2)
        autoreleasepool {
            do {
                var images = [UIImage]()
                (0..<3).forEach {
                    images.append(UIImage(contentsOfFile: getImagePath($0))!)
                }
                if outputAsData {
                    let data = try PDFGenerator.generate(images)
                    data.writeToFile(dst, atomically: true)
                } else {
                    try PDFGenerator.generate(images, outputPath: dst, dpi: .Custom(144), password: "123456")
                }
                openPDFViewer(dst)
            } catch (let e) {
                print(e)
            }
        }
    }
    
    @objc @IBAction private func generateSamplePDFFromImagePaths(sender: AnyObject?) {
        do {
            let dst = getDestinationPath(3)
            var imagePaths = [String]()
            (3..<6).forEach {
                imagePaths.append(getImagePath($0))
            }
            if outputAsData {
                let data = try PDFGenerator.generate(imagePaths)
                data.writeToFile(dst, atomically: true)
            } else {
                try PDFGenerator.generate(imagePaths, outputPath: dst)
            }
            openPDFViewer(dst)
        } catch (let e) {
            print(e)
        }
    }
    
    @objc @IBAction private func generateSamplePDFFromPages(sender: AnyObject?) {
        let v1 = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        v1.backgroundColor = UIColor.redColor()
        let v2 = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 200))
        v2.backgroundColor = UIColor.greenColor()
        
        let page1 = PDFPage.View(v1)
        let page2 = PDFPage.View(v2)
        let page3 = PDFPage.WhitePage(CGSize(width: 200, height: 100))
        let page4 = PDFPage.Image(UIImage(contentsOfFile: getImagePath(1))!)
        let page5 = PDFPage.ImagePath(getImagePath(2))
        let pages = [page1, page2, page3, page4, page5]
        do {
            let dst = getDestinationPath(3)
            if outputAsData {
                let data = try PDFGenerator.generate(pages)
                data.writeToFile(dst, atomically: true)
            } else {
                try PDFGenerator.generate(pages, outputPath: dst)
            }
            openPDFViewer(dst)
        } catch (let e) {
            print(e)

        }
    }
    
    @objc @IBAction private func generatePDFFromStackedScrollView(_: AnyObject?) {
        func getUIView() -> UIView{
            var result = UIView()
            let storyboard = UIStoryboard(name: "PDFOutput", bundle: nil)
            let vc = storyboard.instantiateInitialViewController()!
            vc.view.frame.size = CGSize(width: 595, height: 842)
            // fill view Controller with Data
            for view in vc.view.subviews{
                if view is UIScrollView{
                    (view as! UIScrollView).contentSize = CGSize(width: 595, height: 1684)
                    result = view as! UIScrollView
                }
            }
            return result
        }
        let dst = NSHomeDirectory().stringByAppendingString("/test.pdf")
        try! PDFGenerator.generate(getUIView(), outputPath: dst)
        openPDFViewer(dst)
    }

    private func openPDFViewer(pdfPath: String) {
        let url = NSURL(fileURLWithPath: pdfPath)        
        let storyboard = UIStoryboard(name: "PDFPreviewVC", bundle: nil)
        let vc = storyboard.instantiateInitialViewController() as! PDFPreviewVC
        vc.setupWithURL(url)
        presentViewController(vc, animated: true, completion: nil)
    }

    @objc @IBAction private func goSampleTableView(sender: AnyObject?) {
        let storyboard = UIStoryboard(name: "SampleTableViewController", bundle: nil)
        let vc = storyboard.instantiateInitialViewController() as! SampleTableViewController
        presentViewController(vc, animated: true, completion: nil)
    }
    
    @objc @IBAction private func goSampleWebView(sender: AnyObject?) {
        let storyboard = UIStoryboard(name: "WebViewController", bundle: nil)
        let vc = storyboard.instantiateInitialViewController() as! WebViewController
        presentViewController(vc, animated: true, completion: nil)
    }

}
