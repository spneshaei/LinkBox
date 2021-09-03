//
//  AddFolderView.swift
//  LinkBox
//
//  Created by Seyyed Parsa Neshaei on 9/3/21.
//

import SwiftUI

struct AddFolderView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.presentationMode) var presentationMode
    
    @State var folderName = ""
    @Binding var presentation: Bool
    
    func addFolder() {
        let folder = FolderEntity(context: managedObjectContext)
        folder.folderID = UUID().uuidString
        folder.name = folderName
        folder.dateCreated = Date()
        do {
            try managedObjectContext.save()
            presentation = false
            presentationMode.wrappedValue.dismiss()
        } catch {
            print("Error!")
        }
    }
    
    var body: some View {
        Form {
            TextField("نام موضوع", text: $folderName)
        }
        .navigationBarTitle(Text("افزودن موضوع"))
        .toolbar {
            Button {
                addFolder()
            } label: {
                Text("افزودن").bold()
            }
        }
    }
}

struct AddFolderView_Previews: PreviewProvider {
    static var previews: some View {
        AddFolderView(presentation: .constant(true))
    }
}
