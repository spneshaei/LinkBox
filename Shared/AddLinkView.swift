//
//  AddLinkView.swift
//  LinkBox
//
//  Created by Seyyed Parsa Neshaei on 9/3/21.
//

import SwiftUI

struct AddLinkView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.presentationMode) var presentationMode
    
    var folderID: String
    
    @State var linkName = ""
    @State var linkAddress = ""
    
    @Binding var presentation: Bool
    
    func addLink() {
        let link = LinkEntity(context: managedObjectContext)
        link.address = linkAddress
        link.name = linkName.isEmpty ? "بدون نام" : linkName
        link.folderID = folderID
        link.dateCreated = Date()
        do {
            try managedObjectContext.save()
            presentationMode.wrappedValue.dismiss()
        } catch {
            print("Error!")
        }
    }
    
    var addLinkButton: some View {
        Button {
            addLink()
        } label: {
            Text("افزودن").bold()
        }
    }
    
    var body: some View {
        Form {
            TextField("نام لینک", text: $linkName)
            TextField("آدرس لینک", text: $linkAddress)
        }
        .onAppear {
            #if os(iOS)
            if let address = UIPasteboard.general.string {
                linkAddress = address
            }
            #endif
        }
        .navigationTitle(Text("افزودن لینک"))
        .toolbar {
            addLinkButton
        }
    }
}

struct AddLinkView_Previews: PreviewProvider {
    static var previews: some View {
        AddLinkView(folderID: "", presentation: .constant(true))
    }
}
