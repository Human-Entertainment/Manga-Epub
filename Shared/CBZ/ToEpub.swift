import Combine
import Foundation

class ToEpub: ObservableObject {
    @Published var filePath: String = ""
    
    func completion(result: Result<URL, Error>?) {
        result.map { [self] result in
            switch result {
                case .success(let url):
                    self.filePath = url.absoluteString
                    break
                case .failure(let error):
                    self.filePath = error.localizedDescription
                    break
            }
        }
    }
}
