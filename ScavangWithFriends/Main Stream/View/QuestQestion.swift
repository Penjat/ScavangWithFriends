//
//  QuestQestion.swift
//  ScavangWithFriends
//
//  Created by Spencer Symington on 2021-05-16.
//

import SwiftUI
import Combine

struct QuestQestion: View {
	init(question: String, completed: Bool, answer: String? = nil, publisher: PassthroughSubject<MainStreamViewIntent, Never>? = nil ) {
		self.question = question
		self.complete = completed
		self.answer = answer
		self.self.output = publisher
	}
	var question: String
	var complete: Bool
	var answer: String?
	var output: PassthroughSubject<MainStreamViewIntent, Never>?
    var body: some View {
		HStack{
			Text(question).font(.title).padding(20)
			Spacer()
			Text(answer ?? "???").font(.title2).padding(20)
		}.background(backgroundColor).cornerRadius(40).padding(20).onTapGesture {
			output?.send(.pressedButton)
		}
	}

	var backgroundColor: Color {
		complete ? Color.green : Color.gray
	}
}

struct QuestQestion_Previews: PreviewProvider {
    static var previews: some View {
		QuestQestion(question: "A", completed: false)
    }
}
