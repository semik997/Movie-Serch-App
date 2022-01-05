//
//  MoreInfoMainVC.swift
//  Movie Search App
//
//  Created by Sem Koliesnikov on 27.12.2021.
//

import UIKit

class MoreInfoViewController: UIViewController {
    
    var detailedInformation: Films.Film?
    
    @IBOutlet weak var moreInfoImage: UIImageView!
    @IBOutlet weak var moreIntoTextView: UITextView!
    @IBOutlet weak var YTButton: UIButton!
    
    // MARK: - Configuring a button to open a window with search in You Tube
    
    @IBAction private func searchInYTButton(_ sender: UIButton) {
        let youtubeUser =  detailedInformation?.show?.name
        let text = youtubeUser?.split(separator: " ").joined(separator: "%20")
        let appURL = NSURL(string: "\(appYouTubeLink)\(text ?? "")")
        let webURL = NSURL(string: "\(safariYouTubeLink)\(text ?? "")")
        let application = UIApplication.shared
        
        if application.canOpenURL(appURL! as URL) {
            // open URL inside app
            application.open(appURL! as URL)
        } else {
            // if Youtube app is not installed, open URL inside Safari
            application.open(webURL! as URL)
        }
    }
    
    // MARK: - Configuring new window with additional information
    private func setupMoreInformation () {
        if detailedInformation != nil {
            moreInfoImage.image = getImage(from: detailedInformation?.show?.image?.original ??
                                           placeholderFilm)
            let summary = detailedInformation?.show?.summary ?? "No description text"
            moreIntoTextView.text = summary.htmlString
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMoreInformation ()
    }
    
    
    @IBAction func exit(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - String in image conversion
    
    func getImage(from string: String) -> UIImage? {
        //Get valid URL
        guard let url = URL(string: string)
        else {
            print("Unable to create URL")
            return nil
        }
        
        var image: UIImage? = nil
        do {
            //Get valid data
            let data = try Data(contentsOf: url, options: [])
            
            //Make image
            image = UIImage(data: data)
        } catch {
            print(error.localizedDescription)
        }
        return image
    }
}

extension String {
    var utfData: Data? {
        return self.data(using: .utf8)
    }
    
    var htmlAttributedString: NSAttributedString? {
        guard let data = self.utfData else {
            return nil
        }
        do {
            return try NSAttributedString(data: data,
                                          options: [
                                            .documentType: NSAttributedString.DocumentType.html,
                                            .characterEncoding: String.Encoding.utf8.rawValue],
                                          documentAttributes: nil)
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    var htmlString: String {
        return htmlAttributedString?.string ?? self
    }
}
