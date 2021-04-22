//
//  TesseractViewController.swift
//  campus-rally
//
//  Created by Yuka Okada on 2021/04/21.
//

import UIKit
import SwiftyTesseract

class TesseractViewController: UIViewController {
    
    let swiftyTesseract = SwiftyTesseract(language: RecognitionLanguage.japanese)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Do any additional setup after loading the view.
        let start = Date()

        //let fileName = "kochikan.JPG"
        guard let image = UIImage(named: "kochikan") else { return }

        swiftyTesseract.performOCR(on: image) { recognizedString in
            guard let text = recognizedString else { return }
            print("\(text)")
        }
        
        print("end")
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
