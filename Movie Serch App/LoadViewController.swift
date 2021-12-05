//
//  LoadViewController.swift
//  Movie Serch App
//
//  Created by Семен Колесников on 05.12.2021.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var progress: UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        progress.setProgress(0, animated: true)

        Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { _ in
            if self.progress.progress != 1 {
                self.progress.progress += 0.1
            } else {
                    self.performSegue(withIdentifier: "SegueName", sender: self)
//                let vc = self.storyboard?.instantiateViewController(withIdentifier: "MainVC")
//                self.present(vc!, animated: true, completion: nil)
            }
        }
    }
}
