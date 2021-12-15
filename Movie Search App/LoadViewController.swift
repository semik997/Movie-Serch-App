//
//  LoadViewController.swift
//  Movie Serch App
//
//  Created by Sem Koliesnikov on 05.12.2021.
//

import UIKit

class LoadViewController: UIViewController {
    
    // Customization loading screen 
    
    @IBOutlet weak var progress: UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        progress.setProgress(0, animated: true)
        
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in  // initialization of a timer to fill the download field
            if self.progress.progress != 1 {
                self.progress.progress += 0.05
            } else { // switching to another screen after filling in the loading field
                
                timer.invalidate()
                
                
                self.performSegue(withIdentifier: "LoadSegue", sender: self)
            }
        }
    }
}
