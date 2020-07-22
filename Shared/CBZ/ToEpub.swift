import Combine
import Foundation
import ZIPFoundation

class ToEpub: ObservableObject {
    @Published var filePathComponent = ""
    @Published var isFinished: IsFinished = .notFinished
    
    var fileURL: URL? = nil
    
    func completion(result: Result<URL, Error>?, onFailure: () -> () ){
        print("Reading ZIP")
        guard case .success(let url) = result
        else {
            onFailure()
            return
        }
        self.filePathComponent = url.lastPathComponent
        self.fileURL = url
        
        self.disassambleZip()
        print("Read ZIP")
    }
    
    func disassambleZip() {
        DispatchQueue.init(label: filePathComponent).async {
            guard let fileURL = self.fileURL else { return }
            
            let fileManager = FileManager()
            let destination = fileManager.temporaryDirectory.appendingPathComponent(self.filePathComponent)
            do {
                try fileManager.createDirectory(at: destination, withIntermediateDirectories: true, attributes: nil)
                try fileManager.unzipItem(at: fileURL, to: destination)
                
                print(destination.hasDirectoryPath)
            } catch {
                print("Issues loading zip with \(error)")
            }
        }
    }
    
    func publishEpub(url: URL) {
        DispatchQueue.main.async {
            self.isFinished = .epub(url)
        }
    }
    
    enum IsFinished {
        case notFinished
        case epub(URL)
    }
}
