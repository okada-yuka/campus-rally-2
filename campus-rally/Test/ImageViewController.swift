//
//  ImageViewController.swift
//  campus-rally
//
//  Created by Yuka Okada on 2021/04/21.
//

import UIKit
import opencv2
import SwiftyTesseract

class ImageViewController: UIViewController {

    @IBOutlet weak var srcImageView: UIImageView!
    @IBOutlet weak var dstImageView: UIImageView!
    @IBOutlet weak var dstImageView2: UIImageView!
    @IBOutlet weak var grayImageView: UIImageView!
    @IBOutlet weak var blurImageView: UIImageView!
    
    let swiftyTesseract = SwiftyTesseract(language: RecognitionLanguage.japanese)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //元画像
        let image = UIImage(named: "kochikan")!
        self.srcImageView.image = image
        
        //グレイスケール化
        let gray_image = self.convertColor(source: image)
        self.grayImageView.image = gray_image
        
        //ぼかし
        let blur_image = self.toBlur(source: gray_image)
        self.blurImageView.image = blur_image
        
        //閾値処理
        //単純閾値処理
        self.dstImageView.image = self.convertThresh(source: gray_image)
        self.dstImageView2.image = self.convertThresh(source: blur_image)
        
        //適応型閾値処理
        //self.dstImageView2.image = self.convertAdaptiveThresh(source: gray_image)
        
        let start = Date()

        //let fileName = "kochikan.JPG"
        guard let image_out = self.dstImageView2.image else { return }

        swiftyTesseract.performOCR(on: image_out) { recognizedString in
            guard let text = recognizedString else { return }
            print("\(text)")
        }
        
        print("end")

    }
    
    func convertColor(source srcImage: UIImage) -> UIImage {
        let srcMat = Mat(uiImage: srcImage)
        let dstMat = Mat()
        Imgproc.cvtColor(src: srcMat, dst: dstMat, code: .COLOR_RGB2GRAY)
        return dstMat.toUIImage()
    }

    func toBlur(source grayImage: UIImage) -> UIImage {
        let srcMat = Mat(uiImage: grayImage)
        let dstMat = Mat()
        
        Imgproc.GaussianBlur(src: srcMat, dst: dstMat, ksize: Size(width: 5,height: 5), sigmaX: 3)
        return dstMat.toUIImage()
    }

    func convertThresh(source grayImage: UIImage) -> UIImage {
        let srcMat = Mat(uiImage: grayImage)
        let dstMat = Mat()
        let thresh:Double = 120
        let maxValue:Double = 255
        
        Imgproc.threshold(src: srcMat, dst: dstMat, thresh: thresh, maxval: maxValue, type: .THRESH_BINARY_INV)
        return dstMat.toUIImage()
    }
    
    func convertAdaptiveThresh(source grayImage: UIImage) -> UIImage {
        let srcMat = Mat(uiImage: grayImage)
        let dstMat = Mat()
        let maxValue:Double = 255
        
        Imgproc.adaptiveThreshold(src: srcMat, dst: dstMat, maxValue: maxValue, adaptiveMethod: .ADAPTIVE_THRESH_GAUSSIAN_C, thresholdType: .THRESH_BINARY, blockSize: 11, C: 2)
        return dstMat.toUIImage()
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
