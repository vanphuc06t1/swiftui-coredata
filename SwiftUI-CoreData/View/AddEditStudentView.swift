//
//  AddEditStudentView.swift
//  SwiftUI-CoreData
//
//  Created by Phuc Bui  on 9/24/21.
//

import Foundation
import SwiftUI

struct AddEditStudentView: View {
    
    //MARK: - States
    @State var name = ""
    @State var dateOfBirth = Date()
    
    //MARK: - Binding
    @Binding var showSheet: SheetView?
    
    let onComplete: (String, Date) -> Void
    
    //MARK: - Constants
    private struct Constants {
        static let Name = "Name"
        static let BirthDate = "Birth Date"
        static let DateOfBirth = "Date of birth"
        static let AddStudent = "Add Student"
        static let EditStudent = "Update Student"
        static let DefaultStudentName = "An undefined name"
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text(Constants.Name)) {
                    TextField(Constants.Name, text: $name)
                }
                Section(header: Text(Constants.BirthDate)) {
                    DatePicker(
                        selection: $dateOfBirth,
                        displayedComponents: .date) {
                        Text(Constants.DateOfBirth).foregroundColor(Color(.gray))
                    }
                }
                Section {
                    HStack {
                        Spacer()
                        Button(action: updateStudentAction) {
                            
                            Group {
                                if showSheet == .add {
                                    Text(Constants.AddStudent)
                                } else if showSheet == .edit {
                                    Text(Constants.EditStudent)
                                }
                            }
                            
                        }
                        Spacer()
                    }
                    
                }
            }
            .navigationBarTitle((showSheet == .add) ? Text(Constants.AddStudent) : Text(Constants.EditStudent), displayMode: .inline)
        }
    }
    
    private func updateStudentAction() {
        onComplete(
            name.isEmpty ? Constants.DefaultStudentName : name,
            dateOfBirth)
        self.showSheet = nil
    }
}

