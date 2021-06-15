//
//  ListSettings.swift
//  CheckList
//
//  Created by pioner on 03.06.2021.
//

import SwiftUI

struct ListSettings: View {
    @ObservedObject var viewModel: ViewModel
    @Environment(\.presentationMode) var presentationMode
    
    var editableList: TaskList?
    @Binding var isPresentedSettings: Bool
    @State var nameList: String
    @State var colorList: Color
    @State var isActiveList: Bool
    
    init(viewModel: ViewModel, editableList: TaskList?, isPresentedSettings: Binding<Bool>,colorList: Color) {
        self.viewModel = viewModel
        self.editableList = editableList
        _isPresentedSettings = isPresentedSettings
        _nameList = State(initialValue: editableList?.name ?? "")
        _colorList = State(initialValue: colorList)
        _isActiveList = State(initialValue: editableList?.isActive ?? false)
    }
    
    var body: some View {
        Form {
            HStack {
                Text("List name:")
                TextField("name", text: $nameList).textFieldStyle(RoundedBorderTextFieldStyle())
            }
            
            ColorPicker("Color List", selection: $colorList)
            
            Toggle(isOn: $isActiveList, label: {
                Text("Active list")
            })
            
            HStack {
                Button("Ok") {
                    if let editableList = editableList, nameList != "" {
                        viewModel.editList(list: editableList, name: nameList,color: UIColor(colorList))
                        viewModel.changeStateActiveList(list: editableList, state: isActiveList)
                    } else {
                        let _ = viewModel.addList(name: nameList, color: UIColor(colorList), state: isActiveList)
                    }
                    presentationMode.wrappedValue.dismiss()
                    
                }
                .frame(maxWidth: .infinity)
                .buttonStyle(BorderlessButtonStyle())
                
                Divider()
                Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                }
                .frame(maxWidth: .infinity)
                .buttonStyle(BorderlessButtonStyle())
                
            }
        }
    }
    
    mutating func setEditableList(list: TaskList?) {
        self.editableList = list
    }
}
