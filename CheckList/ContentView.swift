//
//  ContentView.swift
//  CheckList
//
//  Created by pioner on 21.05.2021.
//

import SwiftUI

struct MainView: View {
    
    @StateObject var viewModel = ViewModel()
    
    @State var nameList: String = ""
    @State var nameTask: String = ""
    @State var edditingList = false
    
    @State private var showDialog = false
    
    @State var showsAlert = false
    @State var editableTask: Task? = nil
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(viewModel.tasks) { task in
                        CellTask(viewModel: viewModel, task: task, edditingList: $edditingList, showsAlert: $showsAlert, editableTask: $editableTask)
                    }
                    .onDelete(perform: viewModel.deleteTask)
                    .onMove(perform: moveTask(from:to:))
                    .onLongPressGesture {
                        withAnimation {
                            edditingList.toggle()
                        }
                    }
                }
                .listStyle(PlainListStyle())
                .environment(\.editMode, edditingList ? .constant(EditMode.active) : .constant(EditMode.inactive))
                
                HStack {
                    TextField("Neme Tsk", text: $nameTask)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    Button("New Task") {
                        viewModel.addTask(name: nameTask)
                        nameTask = ""
                    }
                }
                .padding()
                
                
                EmptyView()
                    .alert(isPresented: $showsAlert, TextAlert(title: "Edit \(editableTask?.name ?? "")", text: editableTask?.name ?? "", action: {
                    if let newName = $0, let editTask = editableTask {
                        viewModel.editTask(task: editTask, name: newName)
                    }
                        editableTask = nil
                }))
                    .frame(width: 0, height: 0)
            }
            .navigationBarTitle("\(viewModel.listActive?.name ?? "")", displayMode: .inline)
            .navigationBarItems(leading: MenuLists(viewModel: viewModel), trailing: buttonEdditingList() )
            
        }
    }
    
    func moveTask(from source: IndexSet, to destination: Int){
        viewModel.moveTask(from: source, to: destination)
        withAnimation {
            self.edditingList = false
        }
    }
    
    func buttonEdditingList() -> Button<Image> {
        return Button(action: {
            withAnimation {
                self.edditingList.toggle()
            }
        }, label: {
            Image(systemName: "text.insert")
        })
    }
    
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
