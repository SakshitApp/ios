//
//  EditLessonView.swift
//  iOSSakshitApp
//
//  Created by Punit Chhajer on 01/04/21.
//

import SwiftUI
import shared
import URLImage

struct EditLessonView: View {
    @ObservedObject private(set) var viewModel: ViewModel
    var body: some View {
        ZStack(alignment: .top) {
            ScrollView {
                LazyVStack(spacing: 0) {
                    ZStack(alignment: .bottomTrailing) {
                        if let url = URL(string: viewModel.image ?? "") {
                                
                            URLImage(url: url) { () -> Image in
                                Image(systemName: "photo.fill")
                            } inProgress: { (pregress) -> Image in
                                Image(systemName: "photo.fill")
                            } failure: { (error, retry) -> Image in
                                Image(systemName: "photo.fill")
                            } content: { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                            }
                            .frame(height: 200)
                            .clipped()
                            .foregroundColor(.black)
                        } else {
                            Image(systemName: "photo.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(height: 200)
                                .padding([.top, .bottom, .leading], 8)
                                .foregroundColor(.black)
                                .clipped()
                        }
                        ButtonView(text: "Upload", type: .filled(25), action: {
                        }).frame(width: 100)
                        .padding()
                    }
                    VStack {
                    TextFieldView(title: "Title", text: $viewModel.title)
                        .padding([.top, .horizontal], 10)
                    TextFieldView(title: "Description", text: $viewModel.desciption)
                        .padding([.top, .horizontal], 10)
                    TextFieldView(title: "Youtube URL", text: $viewModel.content)
                            .padding([.top, .horizontal], 10)
                        Text("--- OR ---")
                            .padding([.top, .horizontal], 10)
                        HStack {
                            Text("Select video or pdf only")
                            Spacer()
                            ButtonView(text: "Upload", type: .filled(25), action: {
                            }).frame(width: 100)
                        }
                        .padding([.top, .horizontal], 10)
                    }
                    
                    Text("Questions").bold().frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                        .padding([.top, .horizontal], 10)
                    if let questions = viewModel.data?.question {
                        ForEach(questions, id: \.uuid) { item in
                            ZStack {
                                NavigationLink(destination: EditQuestionView(viewModel: EditQuestionView.ViewModel(repository: CourseRepository(), courseId: viewModel.courseId, lessonId: viewModel.lessonId, questionId: item.uuid))) {
                                    CourseStatusRow(url: nil, showImage: false, title: item.question ?? "<question>", subtitle: item.correct ?? "<answer>", status: "Options: \(item.answers.count)") {
//                                        viewModel.delete(course: item)
                                    }
                                }
                            }
                        }
                    }
                    NavigationLink(destination: EditQuestionView(viewModel: EditQuestionView.ViewModel(repository: CourseRepository(), courseId: viewModel.courseId, lessonId: viewModel.lessonId))) {
                        Text("+ Add New Question")
                    }
                    .padding()
                    HStack {
                        Text("Question to pass lesson")
                        Spacer()
                        Text(viewModel.passing)
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

struct EditLessonView_Previews: PreviewProvider {
    static var previews: some View {
        EditLessonView(viewModel: EditLessonView.ViewModel(repository: CourseRepository()))
    }
}

extension EditLessonView {
    
    class ViewModel: ObservableObject {
        let repository: CourseRepository
        @Published var loading = false
        @Published var error:String? = ""
        @Published var data: shared.Lesson? = nil
        @Published var image: String? = nil
        @Published var title: String = ""
        @Published var content: String = ""
        @Published var desciption: String = ""
        @Published var questions = [shared.Question]()
        @Published var passing: String = ""
        let courseId: String?
        let lessonId: String?
        
        init(repository: CourseRepository, courseId: String? = nil, lessonId: String? = nil) {
            self.repository = repository
            self.courseId = courseId
            self.lessonId = lessonId
            self.load(courseId: courseId, lessonId: lessonId)
        }
        
        func load(courseId: String? = nil, lessonId: String? = nil) {
            self.loading = true
            repository.getDraftCourse(id: courseId, completionHandler: { (course, error) in
                self.loading = false
                if let lessons = course?.lessons {
                    lessons.forEach { (lesson) in
                        if(lesson.uuid == lessonId) {
                            self.data = lesson
                            self.title = lesson.title ?? ""
                            self.desciption = lesson.description_ ?? ""
                            self.image = lesson.image
                            self.content = lesson.content ?? ""
                            self.questions = lesson.question
                            self.passing = "\(lesson.passingQuestion)"
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
