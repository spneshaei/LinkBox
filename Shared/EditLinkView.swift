//
//  EditLinkView.swift
//  LinkBox
//
//  Created by Seyyed Parsa Neshaei on 9/3/21.
//

import SwiftUI

struct EditLinkView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.presentationMode) var presentationMode
    
    var link: LinkEntity
    
    @State var linkName = ""
    @State var linkAddress = ""
    
    @Binding var presentation: Bool
    
    func editLink() {
        link.address = linkAddress
        link.name = linkName.isEmpty ? "بدون نام" : linkName
        do {
            try managedObjectContext.save()
            presentationMode.wrappedValue.dismiss()
        } catch {
            print("Error!")
        }
    }
    
    var editLinkButton: some View {
        Button {
            editLink()
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
            linkName = link.name ?? ""
            linkAddress = link.address ?? ""
        }
        .navigationTitle(Text("تغییر لینک"))
        .toolbar {
            editLinkButton
        }
    }
}
