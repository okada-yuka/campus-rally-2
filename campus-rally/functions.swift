//
//  CharactorRecognition.swift
//  campus-rally
//
//  Created by Yuka Okada on 2021/04/22.
//

import Foundation
import UIKit
import opencv2
import SwiftyTesseract

class functions: NSObject {
    // 画像処理（前処理）と文字認識を行う
    class func charactor_recognition(input_image: UIImage) -> String{

        print("start")
        let swiftyTesseract = SwiftyTesseract(language: RecognitionLanguage.japanese)
        var text = ""
        //元画像
        let image = input_image
        
        //グレイスケール化
        let gray_image = convertColor(source: image)
        
        //ぼかし
        let blur_image = toBlur(source: gray_image)
        
        //閾値処理
        //単純閾値処理
        let dst_Image = convertThresh(source: gray_image)
        let dst_Image2 = convertThresh(source: blur_image)
        
        let start = Date()

        //let fileName = "kochikan.JPG"
        //guard let image_out = dst_Image2 else { return }

        swiftyTesseract.performOCR(on: dst_Image2) { recognizedString in
            guard let text_out = recognizedString else { return }
//            print("\(text_out)")
            
            text = text_out
        }
        
        print("end")
        
        return text
    }
    
    // 正誤判定を行う
    class func judgement(input_text: String, correct_labels: String...) -> Bool{
        var index: Int = 0
        
        for cl in correct_labels{
            index = 0
            var cl_array = Array(cl)
            for chr in cl_array{
                index += 1
                if (!input_text.contains(chr)){
                    break
                }else{
                    if (index == cl_array.count){
                        print(index)
                        print(chr)
                        print(cl)
                        return true
                    }
                }
            }
        }
        
        
        return false
//        print(correct_labels)
//        print(correct_labels[0].count)
//        print(correct_labels[1].count)
//        print(correct_labels[2].count)
//
//        for c_label in correct_labels{
//            print(c_label)
//            for chr in c_label{
//                print(c_label[3])
//            }
//        }
//        return true
//        for c_label in correct_labels{
//            for chr in c_label{
//    //            print(chr)
//                // correct_labelを1文字ずつinput_textと比較し、含まれていない場合falseを返す
//                if (!input_text.contains(chr)){
//                    print("break")
//                    print(chr)
//                    print(c_label)
//                    break
//                }
//                if (chr == c_label[c_label.count]){
//                    print("最後まで回った")
//                    print(chr)
//                    print(c_label[length(c_label)])
//                    print()
//                }
//                print(chr)
//            }
////            print(c_label)
//            return true
//        }
//        return false
    }
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

