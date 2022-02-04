//
//  MoreInfoMainVC.swift
//  Movie Search App
//
//  Created by Sem Koliesnikov on 27.12.2021.
//

import UIKit

class MoreInfoViewController: UIViewController {
    
    @IBOutlet weak var moreInfoImage: UIImageView!
    @IBOutlet weak var moreIntoTextView: UITextView!
    @IBOutlet weak var YTButton: UIButton!
    @IBOutlet weak var nameNavigationItem: UINavigationItem!
    
    var detailedInformation: FavoriteFilm?
    var detail: Films.Film?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupMoreInformation ()
        
        
    }
    
    // MARK: - Configuring new window with additional information
    private func setupMoreInformation () {
        if let info = detailedInformation {
            if let originalLogo = info.original {
                moreInfoImage.image = UIImage(data: (originalLogo))
            }
            let summary = info.nonEmptySummary
            moreIntoTextView.text = summary.htmlString
            nameNavigationItem.title = info.name
        }
        if let info = detail {
            moreInfoImage.image = UIImage.getImage(from: info.show?.image?.original ??
                                           placeholderFilm)
            let summary = info.show?.summary ?? "No description text"
            moreIntoTextView.text = summary.htmlString
            nameNavigationItem.title = detail?.show?.name
        }
    }
    
    // MARK: - Configuring a button to open a window with search in You Tube
    
    @IBAction private func searchInYTButton(_ sender: UIButton) {
        if let info = detailedInformation?.name {
            let youtubeUser =  info
            let text = youtubeUser.split(separator: " ").joined(separator: "%20")
            guard let appURL = NSURL(string: "\(appYouTubeLink)\(text )") else { return }
            guard let webURL = NSURL(string: "\(safariYouTubeLink)\(text )") else { return }
            let application = UIApplication.shared
            
            if application.canOpenURL(appURL as URL) {
                // open URL inside app
                application.open(appURL as URL)
            } else {
                // if Youtube app is not installed, open URL inside Safari
                application.open(webURL as URL)
            }
        }
        
        if let info = detail?.show?.name{
            let youtubeUser =  info
            let text = youtubeUser.split(separator: " ").joined(separator: "%20")
            guard let appURL = NSURL(string: "\(appYouTubeLink)\(text )") else { return }
            guard let webURL = NSURL(string: "\(safariYouTubeLink)\(text )") else { return }
            let application = UIApplication.shared
            
            if application.canOpenURL(appURL as URL) {
                // open URL inside app
                application.open(appURL as URL)
            } else {
                // if Youtube app is not installed, open URL inside Safari
                application.open(webURL as URL)
            }
        }
    }
    
    @IBAction private func exit(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Share function
    
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
}


