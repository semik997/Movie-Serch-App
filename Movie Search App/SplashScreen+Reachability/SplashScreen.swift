//
//  LoadViewController.swift
//  Movie Serch App
//
//  Created by Sem Koliesnikov on 05.12.2021.
//

import UIKit

class SplashScreen: UIViewController {
    
    // Customization loading screen
    
    @IBOutlet weak var progress: UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        progress.setProgress(0, animated: true)
        // initialization of a timer to fill the download field
        Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { timer in
            if self.progress.progress != maxValue {
                self.progress.progress += addValue
            } else { // switching to another screen after filling in the loading field
                
                timer.invalidate()
                
                
                self.performSegue(withIdentifier: "LoadSegue", sender: self)
            }
        }
    }
}
