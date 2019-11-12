//
//  SampleTableViewController.swift
//  PDFGenerator
//
//  Created by Suguru Kishimoto on 2016/02/27.
//
//

import UIKit
import PDFGenerator

class SampleTableViewController: UITableViewController {
    @objc fileprivate func generatePDF() {
        do {
            let dst = NSHomeDirectory() + "/sample_tblview.pdf"
            try PDFGenerator.generate(self.tableView, to: dst)
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

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SampleTableViewCell
        cell.leftLabel.text = "\((indexPath as NSIndexPath).section)-\((indexPath as NSIndexPath).row)cell"
        cell.rightLabel.text = "sample"
        return cell
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "section\(section)"
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        generatePDF()
    }
}
