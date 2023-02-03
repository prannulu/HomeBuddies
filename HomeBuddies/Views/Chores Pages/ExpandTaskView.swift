//
//  ExpandTaskView.swift
//  HomeBuddies
//
//  Created by Pavi Rannulu on 2/3/23.
//

import SwiftUI

struct ExpandTaskView: View {
    @State private var isExpanded = false
    var task : Task
    
    var body: some View {
        if isExpanded == false {
            HStack {
                Text(task.description)
                Image(systemName: "chevron.right.2")
                    .onTapGesture {
                        isExpanded.toggle()
                    }
            }
        } else {
            VStack{
                HStack {
                    Text("Description: \(task.description)")
                    Spacer()
                    Image(systemName: "chevron.down")
                        .onTapGesture {
                            isExpanded.toggle()
                        }
                    
                }
                Text("Created by: \(task.createdBy)")
                Spacer()
                HStack{
                    Spacer()
                    Image(systemName: "trash.circle")
                        .frame(width: 50, height: 50)
                        .foregroundColor(.red)
                        .scaledToFit()
                        .onTapGesture {
                            print("deleting task")
                        }
                    Spacer()
                    Image(systemName: "pencil.circle")
                        .frame(width: 50, height: 50)
                        .foregroundColor(.yellow)
                        .scaledToFit()
                        .onTapGesture {
                            print("editting task")
                        }
                    Spacer()
                }
            }
            
        }
    }
}

//struct ExpandTaskView_Previews: PreviewProvider {
//    static var previews: some View {
//        ExpandTaskView()
//    }
//}
