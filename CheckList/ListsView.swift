//
//  ListsView.swift
//  CheckList
//
//  Created by pioner on 26.05.2021.
//

import SwiftUI

struct ListsView: View {
    
    @ObservedObject var viewModel: ViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State var nameList = ""
    @State var edditingList = false
    @State var editableList: TaskList?
    @State var isPresentedSettings = false
    
    var body: some View {
        
        let localEditableList = self.editableList
        
        return VStack {
            List {
                ForEach(viewModel.lists) { list in
                    CellList(viewModel: viewModel, list: list, edditingList: $edditingList, editableList: $editableList, isPresentedSettings: $isPresentedSettings)
                }
                .onDelete(perform: viewModel.deleteList)
                .onMove(perform: moveList(from:to:))
                .onLongPressGesture {
                    withAnimation {
                        self.edditingList.toggle()
                    }
                }
            }
            .environment(\.editMode, self.edditingList ? .constant(EditMode.active) : .constant(EditMode.inactive))
            
            HStack {
                TextField("Name List", text: $nameList)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Button ("New List") {
                    viewModel.addListAndBecomeActive(name: nameList)
                    nameList = ""
                }
            }
            .padding()
        }
        .navigationBarItems(trailing: buttonNavigationTrailing)
        .sheet(isPresented: $isPresentedSettings, content: {
            ListSettings(viewModel: viewModel, editableList: localEditableList, isPresentedSettings: $isPresentedSettings, colorList: UIColor.getColorDefaultColorBackground(withData: editableList?.color))
        })
        .navigationBarColor(UIColor(UIColor.getColorDefaultColorBackground(withData: viewModel.listActive?.color)))
        .edgesIgnoringSafeArea(.leading)
        .edgesIgnoringSafeArea(.trailing)
        .edgesIgnoringSafeArea(.bottom)
        
    }
    
    @ViewBuilder
    var buttonNavigationTrailing: some View {
        HStack{
            Button {
                print("plus")
                editableList = nil
                isPresentedSettings = true
            } label: {
                Image(systemName: "plus")
            }
            .padding(.trailing, 10)
            
            Button(action: {
                print("edite")
                withAnimation {
                    self.edditingList.toggle()
                }
            }, label: {
                Image(systemName: "text.insert")
            })
        }
    }
    
    func moveList(from source: IndexSet, to destination: Int) {
        viewModel.moveList(from: source, to: destination)
        withAnimation {
            self.edditingList = false
        }
    }
    
}

