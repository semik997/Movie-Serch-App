//
//  MoreInfoMainVC.swift
//  Movie Search App
//
//  Created by Sem Koliesnikov on 27.12.2021.
//

import UIKit

class MoreInfoViewController: UIViewController {
    
    var detailedInformation: FavoriteFilm?
    var detail: Films.Film?
    
    @IBOutlet weak var moreInfoImage: UIImageView!
    @IBOutlet weak var moreIntoTextView: UITextView!
    @IBOutlet weak var YTButton: UIButton!
    @IBOutlet weak var nameNavigationItem: UINavigationItem!
    
    // MARK: - Configuring a button to open a window with search in You Tube
    
    @IBAction private func searchInYTButton(_ sender: UIButton) {
        if detailedInformation?.name == nil {
            let youtubeUser =  detail?.show?.name
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
        } else {
            let youtubeUser =  detailedInformation?.name
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
    }
    
    // MARK: - Configuring new window with additional information
    private func setupMoreInformation () {
        if detailedInformation != nil {
            moreInfoImage.image = UIImage(data: (detailedInformation?.original)!)
            let summary = detailedInformation?.summary ?? "No description text"
            moreIntoTextView.text = summary.htmlString
            nameNavigationItem.title = detailedInformation?.name
        } else {
            moreInfoImage.image = getImage(from: detail?.show?.image?.original ??
                                           placeholderFilm)
            let summary = detail?.show?.summary ?? "No description text"
            moreIntoTextView.text = summary.htmlString
            nameNavigationItem.title = detail?.show?.name
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMoreInformation ()
        
    }
    
    
    @IBAction private func exit(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction private func shareActive(_ sender: UIBarButtonItem) {
        let shareController: UIActivityViewController
        if detail?.show?.externals?.imdb == nil && detail?.show?.url == nil {
        if detailedInformation?.imdb == nil {
            shareController = UIActivityViewController(activityItems: [detailedInformation?.url ?? ""], applicationActivities: nil)
            shareController.completionWithItemsHandler = { _, bool, _, _ in
                if bool {
                    print("Successful")}
            }
        } else {
            shareController = UIActivityViewController(activityItems: ["https://www.imdb.com/title/\(detailedInformation?.imdb ?? "")" ], applicationActivities: nil)
            shareController.completionWithItemsHandler = { _, bool, _, _ in
                if bool {
                    print("Successful")}
            }
        }
        } else {
            if detail?.show?.externals?.imdb == nil {
                shareController = UIActivityViewController(activityItems: [detail?.show?.url ?? ""], applicationActivities: nil)
                shareController.completionWithItemsHandler = { _, bool, _, _ in
                    if bool {
                        print("Successful")}
                }
            } else {
                shareController = UIActivityViewController(activityItems: ["https://www.imdb.com/title/\(detail?.show?.externals?.imdb ?? "")" ], applicationActivities: nil)
                shareController.completionWithItemsHandler = { _, bool, _, _ in
                    if bool {
                        print("Successful")}
                }
            }
        }
        present (shareController, animated: true, completion: nil)
    }
    
    
    
    // MARK: - String in image conversion
    
    private func getImage(from string: String) -> UIImage? {
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

    // MARK: - Extention from html

extension String {
    private var utfData: Data? {
        return self.data(using: .utf8)
    }
    
    var htmlAttributedString: NSAttributedString? {
        guard let data = self.utfData else {
            return nil }
        do {
            return try NSAttributedString(data: data,
                                          options: [
                                            .documentType: NSAttributedString.DocumentType.html,
                                            .characterEncoding: String.Encoding.utf8.rawValue],
                                          documentAttributes: nil)
        } catch {
            print(error.localizedDescription)
            return nil }
    }
    var htmlString: String {
        return htmlAttributedString?.string ?? self }
}
