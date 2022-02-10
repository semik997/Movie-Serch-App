//
//  LoadViewController.swift
//  Movie Serch App
//
//  Created by Sem Koliesnikov on 05.12.2021.
//

import UIKit

class SplashScreen: UIViewController {
    
    // Customization loading screen
    
    private let timeIntervalWithTimer = 0.1
    private let maxValueLoadingBar: Float = 1
    private let addValueLoadingBar: Float = 0.2
    
    @IBOutlet weak var progress: UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        progress.setProgress(0, animated: true)
        // initialization of a timer to fill the download field
        Timer.scheduledTimer(withTimeInterval: timeIntervalWithTimer, repeats: true) { timer in
            if self.progress.progress != self.maxValueLoadingBar {
                self.progress.progress += self.addValueLoadingBar
            } else { // switching to another screen after filling in the loading field
                
                timer.invalidate()
                
                
                self.performSegue(withIdentifier: "LoadSegue", sender: self)
            }
        }
    }
}
