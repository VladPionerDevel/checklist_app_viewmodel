//
//  CellTask.swift
//  CheckList
//
//  Created by pioner on 27.05.2021.
//

import SwiftUI

struct CellTask: View {
    
    @ObservedObject var viewModel: ViewModel
    let task: Task
    
    @Binding var edditingList: Bool
    @Binding var showsAlert: Bool
    @Binding var editableTask: Task?
    
    var body: some View {
        HStack{
            HStack{
                if task.isCheck {
                    Image(systemName: "checkmark.square.fill").foregroundColor(Color(UIColor.systemYellow)).padding(.trailing, 5)
                } else {
                    Image(systemName: "square").padding(.trailing, 5)
                }
                Text("\(task.name ?? "")")
                    .foregroundColor(Color(task.isCheck ? UIColor.systemGray3 : UIColor.label))
                Spacer()
            }
            .font(.title2)
            .padding(7)
            .contentShape(Rectangle())
            .onTapGesture {
                viewModel.toggleTaskCheck(task: task)
            }
            Spacer()
            if edditingList {
                Image(systemName: "pencil.circle").imageScale(.large)
                    .onTapGesture {
                        showsAlert.toggle()
                        editableTask = task
                    }
            }
        }
    }
}


