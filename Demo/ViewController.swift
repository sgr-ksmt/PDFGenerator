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
    
    private var outputAsData :Bool = false

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
    
    @objc @IBAction private func createSamplePDFWithViews(sender: AnyObject?) {
        let v1 = UIScrollView(frame: CGRectMake(0,0,100,100))
        let v2 = UIView(frame: CGRectMake(0,0,100,200))
        let v3 = UIView(frame: CGRectMake(0,0,100,200))
        v1.backgroundColor = UIColor.redColor()
        v1.contentSize = CGSize(width: 100, height: 200)
        v2.backgroundColor = UIColor.greenColor()
        v3.backgroundColor = UIColor.blueColor()
        
        let dst = getDestinationPath(1)
        if outputAsData {
            let data = PDFGenerator.generate([v1, v2, v3])
            data.writeToFile(dst, atomically: true)
        } else {
            PDFGenerator.generate([v1, v2, v3], outputPath: dst)
        }
        openPDFViewer(dst)
    }
    
    @objc @IBAction private func createSamplePDFWithImages(sender: AnyObject?) {
        let dst = getDestinationPath(2)
        autoreleasepool {
            var images = [UIImage]()
            (0..<3).forEach {
                images.append(UIImage(contentsOfFile: getImagePath($0))!)
            }
            if outputAsData {
                let data = PDFGenerator.generate(images)
                data.writeToFile(dst, atomically: true)
            } else {
                PDFGenerator.generate(images, outputPath: dst)
            }
        }
        openPDFViewer(dst)
    }
    
    @objc @IBAction private func createSamplePDFWithImagePaths(sender: AnyObject?) {
        let dst = getDestinationPath(3)
        var imagePaths = [String]()
        (3..<6).forEach {
            imagePaths.append(getImagePath($0))
        }
        if outputAsData {
            let data = PDFGenerator.generate(imagePaths)
            data.writeToFile(dst, atomically: true)
        } else {
            PDFGenerator.generate(imagePaths, outputPath: dst)
        }
        openPDFViewer(dst)
    }

    private func openPDFViewer(pdfPath: String) {
        let url = NSURL(fileURLWithPath: pdfPath)        
        let storyboard = UIStoryboard(name: "PDFPreviewVC", bundle: nil)
        let vc = storyboard.instantiateInitialViewController() as! PDFPreviewVC
        vc.setupWithURL(url)
        presentViewController(vc, animated: true, completion: nil)
    }

}

