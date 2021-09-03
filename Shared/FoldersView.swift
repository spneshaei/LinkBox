//
//  FoldersView.swift
//  LinkBox
//
//  Created by Seyyed Parsa Neshaei on 9/3/21.
//

import SwiftUI

struct FoldersView: View {
    #if os(iOS) || os(macOS)
    typealias MyListStyle = SidebarListStyle
    #else
    typealias MyListStyle = PlainListStyle
    #endif
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(entity: FolderEntity.entity(), sortDescriptors: [
        NSSortDescriptor(keyPath: \FolderEntity.dateCreated, ascending: false)
    ]) var folders: FetchedResults<FolderEntity>
    @FetchRequest(entity: LinkEntity.entity(), sortDescriptors: []) var links: FetchedResults<LinkEntity>
    
    @State private var shouldNavigateToAddFolderView = false
    
    func removeFolders(at offsets: IndexSet) {
        for index in offsets {
            let folder = folders[index]
            
            for link in links {
                if link.folderID == folder.folderID {
                    managedObjectContext.delete(link)
                }
            }
            
            managedObjectContext.delete(folder)
            
            do {
                try managedObjectContext.save()
            } catch {
                print("Error!")
            }
        }
    }
    
    var addNavigation: some View {
        NavigationLink(destination: AddFolderView(presentation: $shouldNavigateToAddFolderView).environment(\.managedObjectContext, managedObjectContext)) {
            Label("Add", systemImage: "plus")
        }
    }
    
    var body: some View {
        VStack {
            List {
                ForEach(folders, id: \.folderID) { folder in
                    NavigationLink(destination: LinksView(folderID: folder.folderID ?? "")) {
                        Label(folder.name ?? "بدون نام", systemImage: "folder")
                    }
                }
                .onDelete(perform: removeFolders)
            }
        }
        .toolbar {
            ToolbarItem {
                addNavigation
            }
        }
        .listStyle(MyListStyle())
        .navigationTitle(Text("موضوعات"))
    }
}

struct FoldersView_Previews: PreviewProvider {
    static var previews: some View {
        FoldersView()
    }
}
