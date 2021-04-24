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
    
    
    // 画像処理（前処理）と文字認識を行う関数
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
    
    // 正誤判定を行う関数
    class func judgement(input_text: String, correct_labels: String...) -> Bool{
        
        var appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.camera_flag = false
        print("camera_flagをfalseにします")
        print(appDelegate.camera_flag)
        
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

    }
    
    // gray_imageとdst_imageを表示する関数
    class func charactor_recognition_view(imageView: UIImageView, imageView2: UIImageView, input_image: UIImage) -> String{

        print("start")
        let swiftyTesseract = SwiftyTesseract(language: RecognitionLanguage.japanese)
        var text = ""
        //元画像
        let image = input_image
        
        //グレイスケール化
        let gray_image = convertColor(source: image)
        
        imageView.image = gray_image
        
        //ぼかし
        let blur_image = toBlur(source: gray_image)
        
        //閾値処理
        //単純閾値処理
        let dst_Image = convertThresh(source: gray_image)
        let dst_Image2 = convertThresh(source: blur_image)
        
        imageView2.image = dst_Image2
        
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
    
    // 結果によってprogressBar、ボタンの状態、クエストの画像、クリア状況を更新する関数
    class func reflect_result(facility_num: Int, quest_num: Int, button: UIButton, label: UILabel, result: Bool){
        var appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        print(result)
        if (result == true){
            print("0.05をたす")
            appDelegate.progress_sum += 0.05
            button.setImage(UIImage(named: "ok"), for: .normal)
            button.isEnabled = false
            label.textColor = #colorLiteral(red: 0.8196078431, green: 0.8196078431, blue: 0.8235294118, alpha: 1)
            //imageView.image = UIImage(named: "checkbox_true")
            appDelegate.clear[facility_num][quest_num] = true
            print(appDelegate.clear[facility_num][quest_num])
            // 施設のクエストを全てクリアしているか
            if appDelegate.clear[facility_num].allSatisfy {$0 == true}{
                print("全クリ")
            }
                
        }else{
            button.setImage(UIImage(named: "retry"), for: .normal)
            label.textColor = #colorLiteral(red: 0.862745098, green: 0.5647058824, blue: 0.5647058824, alpha: 1)
        }
    }
    
    // mainQuest（カメラを使ったクエスト）で呼び出す関数
    class func set_cameraQuest(vc: UIViewController){
        var appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        // カメラorアルバムを呼び出すAlertを生成する
        let c = UIAlertController(title: nil, message: "看板を撮影する", preferredStyle: .actionSheet)
        c.addAction(UIAlertAction(title: "カメラを起動する", style: .default, handler: { action in
            let pc = UIImagePickerController()
            pc.sourceType = .camera
            pc.delegate = vc as! UIImagePickerControllerDelegate & UINavigationControllerDelegate
            vc.present(pc, animated: true, completion: nil)
        }))
        c.addAction(UIAlertAction(title: "アルバムから選択する", style: .default, handler: { action in
            // カメラロールが利用可能か？
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                // 写真を選ぶビュー
                let pickerView = UIImagePickerController()
                // 写真の選択元をカメラロールにする
                pickerView.sourceType = .photoLibrary
                // デリゲート
                pickerView.delegate = vc as! UIImagePickerControllerDelegate & UINavigationControllerDelegate
                // ビューに表示
                vc.present(pickerView, animated: true)
            }
        }))
        c.addAction(UIAlertAction(title: "キャンセル", style: .cancel, handler: { action in
            print("cancelled") // → 外側のビューをタップ or キャンセルボタンタップでここが呼ばれる
        }))
        
        vc.present(c, animated: true, completion: nil)
        
        appDelegate.camera_flag = true

    }
    
    
    
}

// 施設Viewの白背景を描画する関数
class DrawView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        self.backgroundColor = UIColor.clear;
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {

        // 角が丸い四角形（短形）
        let roundrRectangle = UIBezierPath(roundedRect: CGRect(x: 0, y: 445, width: 390, height: 558), cornerRadius: 44.0)
        // 内側の色
        #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).setFill()
        // 内側を塗りつぶす
        roundrRectangle.fill()
//        // 線の色
//        UIColor(red: 0, green: 0.8, blue: 0, alpha: 1.0).setStroke()
//        // 線の太さ
//        roundrRectangle.lineWidth = 2.0
//        // 線を塗りつぶす
//        roundrRectangle.stroke()
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

