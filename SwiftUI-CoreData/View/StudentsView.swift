//
//  StudentsView.swift
//  SwiftUI-CoreData
//
//  Created by Phuc Bui  on 9/24/21.
//

import SwiftUI

enum SheetView: Identifiable {
    var id: Self { self }
    case add, edit
}

struct StudentsView: View {
    
    // MARK: - States
    @State var isPresented = false
    @State var showSheet: SheetView? = nil
    
    @StateObject var viewModel : StudentsViewModel = StudentsViewModel(studentDataService: StudentDataManager() )
    
    //MARK: - Constants
    private struct Constants {
        static let NavigationTitle = "Students"
    }
    
    //MARK: - Body
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.students, id: \.self) { student in
                    
                   StudentView(student: student)
                    .onTapGesture {
                        
                        viewModel.selectedStudent = student
                        showSheet = .edit
                        
                    }
                    
                }
                .onDelete(perform: { indexSet in
                    indexSet.forEach { index in
                        
                        let student = self.viewModel.students[index]
                        self.viewModel.deleteStudent(student: student)
                        
                    }
                })
                
                
            }
            .sheet(item: $showSheet) { mode in
                content(for: mode, student: viewModel.selectedStudent)
            }
            .navigationBarTitle(Text(Constants.NavigationTitle))
            .navigationBarItems(trailing:
                                    Button(action: {
                                        showSheet = .add
                                    }) {
                                        Image(systemName: "plus")
                                    }
            )
            
        }
    }
    
    /// Create view builder for adding and editing student
    ///
    @ViewBuilder
    func content(for mode: SheetView, student: Student?) -> some View {
        
        switch mode {
        case .add:
            AddEditStudentView(showSheet: $showSheet) { name, birthDate in
                //Add Student
                self.viewModel.saveStudent(name: name, dateOfBirth: birthDate)
                //Reset state
                viewModel.selectedStudent = nil
            }
        case .edit:
            AddEditStudentView(name: student?.name ?? "", dateOfBirth: student?.dateOfBirth ?? Date(), showSheet: $showSheet) { (name, dateOfBirth) in
                //Update student 
                guard let student = student else { return }
                student.name = name
                student.dateOfBirth = dateOfBirth
                self.viewModel.updateStudent()
                //reset state value
                viewModel.selectedStudent = nil
                showSheet = nil

            }
        }
    }
}
