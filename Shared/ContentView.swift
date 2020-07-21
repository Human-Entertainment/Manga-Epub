//
//  ContentView.swift
//  Shared
//
//  Created by Bastian Inuk Christensen on 19/07/2020.
//

import SwiftUI
import UniformTypeIdentifiers

struct ContentView: View {
    @State var fileChosen = false
    
    var body: some View {
        VStack {
            Text("Hello, world!").padding()
            if fileChosen {
                PickedFile().padding()
            }
            Button(fileChosen ? "Remove File" : "Pick File") {
                fileChosen.toggle()
            }.padding()
        }
    }
}

struct PickedFile: View {
    
    @Environment(\.importFiles) var file
    @ObservedObject var fileObject: ToEpub
    
    init() {
        fileObject = ToEpub()
        var utArray: [UTType] = [.zip]
        UTType(mimeType: "application/x-cbz", conformingTo: .zip).map { cbzType in
            print("Succesafully found cbz UTType")
            utArray.append(cbzType)
        }
        file.callAsFunction(singleOfType: utArray, completion: fileObject.completion)
       
    }
    
    var body: some View {
        Text(fileObject.filePathComponent)
    }
}










extension View {
    func cbzDrop() -> some View {
        let cbzUTType: UTType? = UTType(mimeType: "application/x-cbz", conformingTo: .zip)
        switch cbzUTType {
            case .some(let cbz):
                return self.onDrop(of: [.zip, cbz], delegate: CBZDropDelegate())
            case .none:
                return self.onDrop(of: [.zip], delegate: CBZDropDelegate())
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
