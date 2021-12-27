//
//  MoreInfoMainVC.swift
//  Movie Search App
//
//  Created by Sem Koliesnikov on 27.12.2021.
//

import UIKit

class MoreInfoViewController: UITableViewController {
    
    @IBOutlet weak var mainMoreInfoImage: UIImageView!
    @IBOutlet weak var mainMoreInfoLabel: UILabel!
    
    var detailedInformation: Films.Film?
    
    private func setupMoreInformation () {
        if detailedInformation != nil {
            mainMoreInfoImage.image = getImage(from: detailedInformation?.show?.image?.original ?? "Not found")
            
            let text = detailedInformation?.show?.summary ?? "No description text".replacingOccurrences(of: "<[^>]+>", with: "")
            mainMoreInfoLabel.text = text
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMoreInformation ()
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
        }catch {
            print(error.localizedDescription)
        }
        return image
    }
}
