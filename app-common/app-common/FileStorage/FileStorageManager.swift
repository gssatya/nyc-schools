//
//  FileStorageManager.swift
//  app-common
//
//  Created by Satya Surya on 12/23/22.
//

import Foundation

/// To handle the file storage logic
public struct FileStorageManager {
    
    private static var documentPath: URL? = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first
    
    /// To store the encodable data on File storage
    /// - Parameters:
    ///      - object: Encodable object
    ///      - filename: Filename string
    public static func store<T: Encodable>(_ object: T, filename: String) throws {
        
        let encoder = JSONEncoder()
        do {
            // Encode the T object.
            let data = try encoder.encode(object)
            
            // Exclude from backing up to iTunes
            
            
            if var url = getURL(for: filename) {
                excludeFromBackup(for: &url)
                
                // remove the file if already present
                if FileManager.default.fileExists(atPath: url.path) {
                    try FileManager.default.removeItem(at: url)
                }
                
                // create the file.
                FileManager.default.createFile(atPath: url.path, contents: data, attributes: nil)
            }
            
        } catch {
            print("Unexpected error: \(error).")
            throw error
        }
    }
    
    /// To retrieve the data from File.
    /// - Returns: Decodable data
    public static func retrieve<T: Decodable>(_ filename: String, as type: T.Type) -> T? {
        
        guard let url = getURL(for: filename),
              FileManager.default.fileExists(atPath: url.path),
              let data = FileManager.default.contents(atPath: url.path) else {
                  print("File not found!")
                  return nil
              }
        
        let decoder = JSONDecoder()
        do {
            let dataModel = try decoder.decode(type, from: data)
            return dataModel
        } catch {
            print("File retrieve failed!")
            return nil
        }
    }
    
    /// Private method to get the URL
    /// - Parameter filename: filename string
    /// - Returns: optional URL.
    private static func getURL(for filename: String) -> URL? {
        return documentPath?.appendingPathComponent(filename)
    }
    
    /// Private method to exclude the file from back up
    /// - Parameter url: URL object.
    private static func excludeFromBackup(for url: inout URL) {
        if !FileManager.default.fileExists(atPath: url.path) {
            FileManager.default.createFile(atPath: url.path, contents: nil, attributes: nil)
        }
        var resourceValues = URLResourceValues()
        resourceValues.isExcludedFromBackup = true
        do {
            try url.setResourceValues(resourceValues)
        } catch {
            print(error.localizedDescription)
            print("Error excluding from backup.")
        }
    }
    
}
