import Combine
import Foundation
import ZIPFoundation

class ToEpub: ObservableObject {
    @Published var filePathComponent = ""
    @Published var isFinished: IsFinished = .notFinished
    
    var fileURL: URL? = nil
    
    func completion(result: Result<URL, Error>?) {
        guard case .success(let url) = result else { return }
        
        self.filePathComponent = url.lastPathComponent
        self.fileURL = url
    }
    
    func disassambleZip() {
        DispatchQueue.init(label: filePathComponent).async {
            guard let fileURL = self.fileURL else { return }
            
            let fileManager = FileManager()
            let destination = fileManager.temporaryDirectory.appendingPathComponent(self.filePathComponent)
            do {
                try fileManager.createDirectory(at: destination, withIntermediateDirectories: true, attributes: nil)
                try fileManager.unzipItem(at: fileURL, to: destination)
            } catch {
                print("Issues loading zip")
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
