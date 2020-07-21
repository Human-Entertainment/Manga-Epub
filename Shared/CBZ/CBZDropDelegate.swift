import SwiftUI

struct CBZDropDelegate: DropDelegate {
    func performDrop(info: DropInfo) -> Bool {
        print(info.location)
        
        return false
    }
    
    
}
