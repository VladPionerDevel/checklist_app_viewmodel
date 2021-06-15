//
//  CellList.swift
//  CheckList
//
//  Created by pioner on 01.06.2021.
//

import SwiftUI

struct CellList: View {
    
    @ObservedObject var viewModel: ViewModel
    var list: TaskList?
    
    @Binding var edditingList: Bool
    @Binding var editableList: TaskList?
    @Binding var isPresentedSettings : Bool
    
    var body: some View {
        HStack{
            Text("\(list?.name ?? "")")
            Spacer()
            if list != nil, list!.isActive {
                Image(systemName: "checkmark").padding(.trailing, 5)
            }
            Rectangle()
                .frame(width: 22, height: 22)
                .foregroundColor(UIColor.getColorDefaultColorBackground(withData: list?.color))
        }
        .font(.title2)
        .padding(7)
        .contentShape(Rectangle())
        .onTapGesture {
            editableList = list
            isPresentedSettings.toggle()
        }
    }
    
}



