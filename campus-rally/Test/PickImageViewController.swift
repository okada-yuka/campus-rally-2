//
//  PickImageViewController.swift
//  campus-rally
//
//  Created by Yuka Okada on 2021/04/22.
//

import UIKit

class PickImageViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let c = UIAlertController(title: nil, message: "めっせーじ", preferredStyle: .actionSheet)
        c.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            
        }))
        c.addAction(UIAlertAction(title: "キャンセル", style: .cancel, handler: { action in
            print("cancelled") // → 外側のビューをタップ or キャンセルボタンタップでここが呼ばれる
        }))
        
        present(c, animated: true, completion: nil)
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
