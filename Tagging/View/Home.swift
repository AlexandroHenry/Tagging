//
//  Home.swift
//  Tagging
//
//  Created by Seungchul Ha on 2023/02/28.
//

import SwiftUI

struct Home: View {
	
	@State var text: String = ""
	
	@State var tags: [Tag] = []
	@State var showAlert: Bool = false
	
    var body: some View {
		VStack {
			
			Text("Filter \nMenus")
				.font(.system(size: 35, weight: .bold))
				.foregroundColor(Color("Tag"))
				.frame(maxWidth: .infinity, alignment: .leading)
			
			TagView(maxLimit: 150, tags: $tags)
				.frame(height: 280)
				.padding(.top, 20)
			
			TextField("apple", text: $text)
				.font(.title3)
				.padding(.vertical, 10)
				.padding(.horizontal)
				.background(
					RoundedRectangle(cornerRadius: 10)
						.strokeBorder(Color("Tag").opacity(0.4), lineWidth: 1)
				)
				.environment(\.colorScheme, .dark)
				.padding(.vertical, 18)
			
			Button {
				
				addTag(tags: tags, text: text, fontSize: 16, maxLimit: 150) { alert, tag in
					if alert {
						// Showing Alert
						showAlert.toggle()
					} else {
						// adding Tag...
						tags.append(tag)
						text = ""
					}
				}
				
			} label: {
				Text("Add Tag")
					.fontWeight(.semibold)
					.foregroundColor(Color("BG"))
					.padding(.vertical, 12)
					.padding(.horizontal, 45)
					.background(Color("Tag"))
					.cornerRadius(10)
			}
			.disabled(text == "")
			.opacity(text == "" ? 0.6 : 1)
		}
		.padding(15)
		.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
		.background(
			Color("BG")
				.ignoresSafeArea()
		)
		.alert(isPresented: $showAlert) {
			Alert(title: Text("Error"), message: Text("Tag Limit Exceeded  try to delete some tags"), dismissButton: .destructive(Text("OK")))
		}
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
