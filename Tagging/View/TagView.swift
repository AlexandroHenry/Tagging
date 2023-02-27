//
//  TagView.swift
//  Tagging
//
//  Created by Seungchul Ha on 2023/02/28.
//

import SwiftUI

struct TagView: View {
	var maxLimit: Int
	@Binding var tags: [Tag]
	
	var title: String = "Add Some Tags"
	var fontSize: CGFloat = 16
	
	// Adding Geometry Effect to Tag...
	@Namespace var animation
	
    var body: some View {
        
		VStack(alignment: .leading, spacing: 15) {
			
			Text(title)
				.font(.callout)
				.foregroundColor(Color("Tag"))
			
			ScrollView(.vertical, showsIndicators: false) {
				
				VStack(alignment: .leading, spacing: 10) {
					
					ForEach(getRows(), id: \.self) { rows in
						
						HStack(spacing: 6) {
							ForEach(rows) { row in
								
								// Row View...
								RowView(tag: row)
							}
						}
					}
					
				}
				.frame(width: UIScreen.main.bounds.width - 80, alignment: .leading)
				.padding(.vertical)
				.padding(.bottom, 20)
			}
			.frame(maxWidth: .infinity)
			.background(
				RoundedRectangle(cornerRadius: 8)
					.stroke(Color("Tag").opacity(0.15), lineWidth: 1)
			)
			// Animation....
			.animation(.easeInOut, value: tags)
			.overlay(
				
				// Limit...
				Text("\(getSize(tags: tags))/\(maxLimit)")
					.font(.system(size: 13, weight: .semibold))
					.foregroundColor(Color("Tag"))
					.padding(12)
				, alignment: .bottomTrailing
			)
		}
    }
	
	@ViewBuilder
	func RowView(tag: Tag) -> some View {
		Text(tag.text)
			.font(.system(size: fontSize))
			.padding(.horizontal, 14)
			.padding(.vertical, 8)
			.background(
				Capsule()
					.fill(Color("Tag"))
			)
			.foregroundColor(Color("BG"))
			.lineLimit(1)
			// Delete...
			.contentShape(Capsule())
			.contextMenu {
				Button("Delete") {
					// Deleting...
					tags.remove(at: getIndex(tag: tag))
				}
			}
			.matchedGeometryEffect(id: tag.id, in: animation)
	}
	
	
	func getIndex(tag: Tag) -> Int {
		
		let index = tags.firstIndex { currentTag in
			return tag.id == currentTag.id
		} ?? 0
		
		return index
	}
	
	// BASIC Logic...
	// Splitting the array when it exceeds the screen size....
	func getRows() -> [[Tag]] {
		
		var rows: [[Tag]] = []
		var currentRow: [Tag] = []
		
		// Calculating text width...
		var totalWidth: CGFloat = 0
		
		// For Safety extra 10....
		let screenWidth: CGFloat = UIScreen.main.bounds.width - 90
		
		tags.forEach { tag in
			
			// updating total width...
			// adding the capsule size into total width with spacing
			// ( 14 + 14 + 6 + 6 )  and extra 6 for safety  ->
			totalWidth += (tag.size + 40)
			
			// checking if totalWidth is greater than size...
			if totalWidth > screenWidth {
				// Adding row in Rows...
				// Clearing the data...
				// Checking for long string
				totalWidth = (!currentRow.isEmpty || rows.isEmpty ? (tag.size + 40) : 0)
				
				rows.append(currentRow)
				currentRow.removeAll()
				currentRow.append(tag)
			} else {
				currentRow.append(tag)
			}
		}
		
		// Safe check...
		// if having any value storing it in rows...
		if !currentRow.isEmpty {
			rows.append(currentRow)
			currentRow.removeAll()
		}
		
		return rows
	}
}

struct TagView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

// Global Function
func addTag(tags: [Tag], text: String, fontSize: CGFloat, maxLimit: Int, completion: @escaping (Bool, Tag) -> ()){

	// getting Text Size....
	let font = UIFont.systemFont(ofSize: fontSize)
	
	let attributes = [NSAttributedString.Key.font: font]
	
	let size = (text as NSString).size(withAttributes: attributes)
	
	print(size)
	
	let tag = Tag(text: text, size: size.width)

	if (getSize(tags: tags) + text.count) < maxLimit {
		completion(false, tag)
	} else {
		completion(true, tag)
	}
}

func getSize(tags: [Tag]) -> Int {
	var count: Int = 0
	
	tags.forEach { tag in
		count += tag.text.count
	}
	
	return count
}
