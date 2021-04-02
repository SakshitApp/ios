//
//  CourseStatusView.swift
//  iOSSakshitApp
//
//  Created by Punit Chhajer on 31/03/21.
//

import SwiftUI
import URLImage
import shared

struct CourseStatusRow: View {
    var url: URL?
    var showImage: Bool = true
    var title: String?
    var subtitle: String?
    var status: String?
    var state: CourseState? = nil
    var onDelete: (() -> Void)?
    var onActivate: ((_ active: CourseState) -> Void)? = nil
    
    var body: some View {
        //        GeometryReader { metrics in
        HStack {
            if let url = url {
                    
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
                .frame(width: 50, height: 50)
                .clipped()
                .foregroundColor(.black)
            } else if (showImage) {
                Image(systemName: "photo.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 50, height: 50)
                    .padding([.top, .bottom, .leading], 8)
                    .foregroundColor(.black)
            }
            VStack( alignment: .leading){
                if let title = title {
                    Text(title)
                        .bold()
                        .lineLimit(2)
                        .padding([.top, .trailing, .leading], 8)
                        .foregroundColor(.black)
                }
                if let subtitle = subtitle {
                    Text(subtitle)
                        .lineLimit(2)
                        .padding([.top, .trailing, .leading], 8)
                        .foregroundColor(.black)
                }
                if let status = status {
                    Text(status)
                        .padding([.top, .trailing, .bottom, .leading], 8)
                        .foregroundColor(.black)
                }
            }
            Spacer()
            VStack( alignment: .leading){
                if let onActivate = onActivate {
                    if (state == CourseState.draft) {
                        Button(action: {
                            onActivate(CourseState.active)
                        }) {
                            Image(systemName: "power")
                                .foregroundColor(.black)
                        }.padding()
                    } else if (state == CourseState.inactive) {
                        Button(action: {
                            onActivate(CourseState.active)
                        }) {
                            Image(systemName: "power")
                                .foregroundColor(.red)
                        }.padding()
                    } else {
                        Button(action: {
                            onActivate(CourseState.inactive)
                        }) {
                            Image(systemName: "power")
                                .foregroundColor(.green)
                        }.padding()
                    }
                }
                if let onDelete = onDelete {
                    Button(action: {
                        onDelete()
                    }) {
                        Image(systemName: "trash.fill")
                            .foregroundColor(Color("AccentColor"))
                    }.padding()
                }
            }
        }
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color(.sRGB, red: 150/255, green: 150/255, blue: 150/255, opacity: 0.1), lineWidth: 2)
        ).padding([.top, .leading, .trailing], 8)
    }
    //    }
}

struct CourseStatusRow_Previews: PreviewProvider {
    static var previews: some View {
        CourseStatusRow(url: URL(string: "https://www.indiewire.com/wp-content/uploads/2019/08/joker-phoenix-1135161-1280x0.jpeg"), title: "title", subtitle: "Subtitle 1", status: "Status", onDelete: {
            
        }, onActivate: {_ in
            
        })
    }
}
