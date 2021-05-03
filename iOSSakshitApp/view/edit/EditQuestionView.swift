//
//  EditQuestionView.swift
//  iOSSakshitApp
//
//  Created by Punit Chhajer on 02/04/21.
//

import SwiftUI
import shared

struct EditQuestionView: View {
    @ObservedObject private(set) var viewModel: ViewModel
    var body: some View {
        ZStack(alignment: .top) {
            ScrollView {
                LazyVStack(spacing: 0) {
                    TextFieldView(title: "Question", text: $viewModel.question)
                            .padding([.top, .horizontal], 10)
                    TextFieldView(title: "Option 1", text: $viewModel.ans1)
                                .padding([.top, .horizontal], 10)
                        TextFieldView(title: "Option 2", text: $viewModel.ans2)
                                    .padding([.top, .horizontal], 10)
                        TextFieldView(title: "Option 3", text: $viewModel.ans3)
                                    .padding([.top, .horizontal], 10)
                        TextFieldView(title: "Option 4", text: $viewModel.ans4)
                                    .padding([.top, .horizontal], 10)
                    HStack {
                        Text("Correct Answer:")
                        Spacer()
                        Text(viewModel.correct)
                        Image(systemName: "arrowtriangle.down.fill")
                    }.padding([.top, .horizontal], 10)
                    ButtonView(text: "Save", type: .filled(25)) {
                        
                    }
                    .padding(.all, 10)
                }
            }
            if (viewModel.loading) {
                LinearProgressView()
                    .frame(height: 5, alignment: .center)
            } else {
                EmptyView().frame(height: 5, alignment: .center)
            }
        }
        .snackBar(text: $viewModel.error)
        .navigationBarTitle("Edit Lesson")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct EditQuestionView_Previews: PreviewProvider {
    static var previews: some View {
        EditQuestionView(viewModel: EditQuestionView.ViewModel(repository: CourseRepository()))
    }
}

extension EditQuestionView {
    
    class ViewModel: ObservableObject {
        let repository: CourseRepository
        @Published var loading = false
        @Published var error:String? = ""
        @Published var data: shared.Question? = nil
        @Published var question: String = ""
        @Published var ans1: String = ""
        @Published var ans2: String = ""
        @Published var ans3: String = ""
        @Published var ans4: String = ""
        @Published var correct: String = ""
        
        init(repository: CourseRepository, courseId: String? = nil, lessonId: String? = nil, questionId: String? = nil) {
            self.repository = repository
            self.load(courseId: courseId, lessonId: lessonId, questionId: questionId)
        }
        
        func load(courseId: String? = nil, lessonId: String? = nil, questionId: String? = nil) {
            self.loading = true
            repository.getDraftCourse(id: courseId, completionHandler: { (course, error) in
                self.loading = false
                if let lessons = course?.lessons {
                    lessons.forEach { (lesson) in
                        if(lesson.uuid == lessonId) {
                            lesson.question.forEach { (question) in
                                if(question.uuid == questionId) {
                                    self.data = question
                                    self.question = question.question ?? ""
                                    if (question.answers.count > 0) {
                                        self.ans1 = question.answers[0]
                                        if ( question.correct == question.answers[0]) {
                                            self.correct = "0"
                                        }
                                    }
                                    if (question.answers.count > 1) {
                                        self.ans1 = question.answers[1]
                                        if ( question.correct == question.answers[1]) {
                                            self.correct = "1"
                                        }
                                    }
                                    if (question.answers.count > 2) {
                                        self.ans1 = question.answers[2]
                                        if ( question.correct == question.answers[2]) {
                                            self.correct = "2"
                                        }
                                    }
                                    if (question.answers.count > 3) {
                                        self.ans1 = question.answers[3]
                                        if ( question.correct == question.answers[3]) {
                                            self.correct = "3"
                                        }
                                    }
                                    
                                }
                            }
                        }
                    }
                } else {
                    self.error = error?.localizedDescription ?? "Error"
                }
            })
        }
        
        func save(course: EditCourse) {
            self.loading = true
            repository.updateDraft(draft: course, completionHandler: { (_, error) in
                if let error = error {
                    self.error = error.localizedDescription
                } else {
                    self.load()
                }
            })
        }
    }
}
