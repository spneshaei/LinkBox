//
//  LinksView.swift
//  LinkBox
//
//  Created by Seyyed Parsa Neshaei on 9/3/21.
//

import SwiftUI

struct LinksView: View {
    #if os(iOS) || os(macOS)
    typealias MyListStyle = SidebarListStyle
    #else
    typealias MyListStyle = PlainListStyle
    #endif
    
    @Environment(\.managedObjectContext) var managedObjectContext
    
    var folderID: String
    
    @State private var shouldNavigateToAddLinkView = false
    @State var searchPredicate = ""

    var body: some View {
        List {
            TextField("جست‌وجو", text: $searchPredicate)
            ForEachLinksView(folderID: folderID, searchPredicate: searchPredicate)
        }
        .listStyle(MyListStyle())
        .navigationTitle(Text("لینک‌ها"))
        .toolbar {
            NavigationLink(destination: AddLinkView(folderID: folderID, presentation: $shouldNavigateToAddLinkView).environment(\.managedObjectContext, managedObjectContext), isActive: $shouldNavigateToAddLinkView) {
                Button {
                    shouldNavigateToAddLinkView = true
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
    }
}

struct ForEachLinksView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    
    var folderID: String
    var searchPredicate: String
    var fetchRequest: FetchRequest<LinkEntity>
    
    @State private var shouldNavigateToEditLinkView = false
    
    init(folderID: String, searchPredicate: String) {
        self.folderID = folderID
        self.searchPredicate = searchPredicate
        fetchRequest = FetchRequest<LinkEntity>(entity: LinkEntity.entity(),
                                              sortDescriptors: [ NSSortDescriptor(keyPath: \LinkEntity.dateCreated, ascending: false)],
                                              predicate: NSPredicate(format: "(folderID == %@) AND (name LIKE %@)", folderID, "*\(searchPredicate)*"))
    }
    
    func removeLinks(at offsets: IndexSet) {
        for index in offsets {
            let link = fetchRequest.wrappedValue[index]
            managedObjectContext.delete(link)
            do {
                try managedObjectContext.save()
            } catch {
                print("Error!")
            }
        }
    }
    
    var body: some View {
        ForEach(fetchRequest.wrappedValue, id: \.self) { link in
            if URL(string: link.address ?? "") != nil {
                
                    Link(destination: URL(string: link.address ?? "")!) {
                        VStack(alignment: .leading) {
                            Text(link.name ?? "بدون نام").font(.title2)
                            Text(link.address ?? "")
                            NavigationLink(destination: EditLinkView(link: link, presentation: $shouldNavigateToEditLinkView).environment(\.managedObjectContext, managedObjectContext), isActive: $shouldNavigateToEditLinkView) {
                                EmptyView()
                            }
                        }
                        .frame(minHeight: 50)
                    }
                .contextMenu {
                    Button {
                        shouldNavigateToEditLinkView = true
                    } label: {
                        Label("تغییر نام", systemImage: "rectangle.and.pencil.and.ellipsis")
                    }
                }
            }
        }
        .onDelete(perform: removeLinks)
    }
}

struct LinksView_Previews: PreviewProvider {
    static var previews: some View {
        LinksView(folderID: "")
    }
}
