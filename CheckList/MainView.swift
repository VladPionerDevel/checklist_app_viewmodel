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
    
    @State var showsAlertEditTask = false
    @State var editableTask: Task? = nil
    @State var isShowListLists = false
    
    @State private var isNavigationToListsView = false
    
    @State var isPresentedSettings = false
    
    var body: some View {
        GeometryReader { bounds in
            ZStack(alignment: Alignment(horizontal: .leading, vertical: .top)){
                NavigationView {
                    VStack {
                        List {
                            ForEach(viewModel.tasks) { task in
                                CellTask(viewModel: viewModel, task: task, edditingList: $edditingList, showsAlert: $showsAlertEditTask, editableTask: $editableTask)
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
                        
                        alertEditTask
                    }
                    .navigationBarTitle("\(viewModel.listActive?.name ?? "")", displayMode: .inline)
                    .navigationBarItems(leading: buttonLists, trailing: buttonSwitchListsEdditingMode )
                    .navigationBarColor(UIColor(UIColor.getColorDefaultColorBackground(withData: viewModel.listActive?.color)))
                    .disabled(isShowListLists)
                    .sheet(isPresented: $isPresentedSettings, content: {
                        ListSettings(viewModel: viewModel, editableList: nil, isPresentedSettings: $isPresentedSettings, colorList: UIColor.getColorDefaultColorBackground(withData: nil))
                    })
                    .background(
                        NavigationLink(destination: ListsView(viewModel: viewModel), isActive: $isNavigationToListsView) {
                            EmptyView()
                        })
                    
                    .edgesIgnoringSafeArea(.trailing)
                    .edgesIgnoringSafeArea(.leading)
                    .edgesIgnoringSafeArea(.bottom)
                }
                .frame(maxWidth: .infinity,maxHeight: .infinity)
                .navigationViewStyle(StackNavigationViewStyle())
                
                MenuList(viewModel: viewModel, isShow: $isShowListLists, isNavigationToListsView: $isNavigationToListsView, isPresentedSettings: $isPresentedSettings, bounds: bounds)
            }
        }
        .edgesIgnoringSafeArea(.trailing)
        .edgesIgnoringSafeArea(.leading)
        .edgesIgnoringSafeArea(.bottom)
    }
    
    @ViewBuilder
    var buttonSwitchListsEdditingMode: some View {
        Button(action: {
            withAnimation {
                self.edditingList.toggle()
            }
        }, label: {
            Image(systemName: "text.insert")
        })
    }
    
    @ViewBuilder
    var alertEditTask: some View {
        EmptyView()
            .alert(isPresented: $showsAlertEditTask, TextAlert(title: "Edit \(editableTask?.name ?? "")", text: editableTask?.name ?? "", action: {
                if let newName = $0, let editTask = editableTask {
                    viewModel.editTask(task: editTask, name: newName)
                }
                editableTask = nil
            }))
            .frame(width: 0, height: 0)
    }
    
    @ViewBuilder
    var buttonLists: some View {
        Button("Lists", action: {
            withAnimation {
                isShowListLists.toggle()
            }
        })
    }
    
    func moveTask(from source: IndexSet, to destination: Int){
        viewModel.moveTask(from: source, to: destination)
        withAnimation {
            self.edditingList = false
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}


