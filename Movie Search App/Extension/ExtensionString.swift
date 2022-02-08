//
//  ExtensionString.swift
//  Movie Search App
//
//  Created by Sem Koliesnikov on 08.02.2022.
//

import Foundation

// MARK: - Extention from html

extension String {
    
    private var utfData: Data? {
        return self.data(using: .utf8)
    }
    private var htmlAttributedString: NSAttributedString? {
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
