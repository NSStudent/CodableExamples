//: [Previous](@previous)
//: # Custom Decodable

import Foundation

let json = """
{
  "tags": ["swift", "kotlin"],
  "swift": {
    "id": 1,
    "company": "Apple",
    "language_name": "Swift"
  },
  "kotlin": {
    "id": 2,
    "company": "JetBrains",
    "language_name": "Kotlin",
  }
}
""".data(using: String.Encoding.utf8)!

struct Language: Codable {
	let identifier: Int
	let company: String
	let name: String
	
	private enum CodingKeys: String, CodingKey {
		case identifier = "id"
		case company
		case name = "language_name"
	}
}

struct Developer: Decodable {
	let languages : [Language]
	
	private struct CodingKeys: CodingKey {
		public var stringValue: String
		
		public init?(stringValue: String) {
			self.stringValue = stringValue
		}
		
		public var intValue: Int? {
			return nil
		}
		
		public init?(intValue: Int) {
			return nil
		}

		static let tags = CodingKeys(stringValue:"tags")!
	}
	
	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		var languages: [Language] = []
		let tags = try container.decode([String].self, forKey: .tags)
		for tag in tags {
			let languageKey = CodingKeys(stringValue: tag)!
			let language = try container.decode(Language.self, forKey: languageKey)
			languages.append(language)
		}
		self.languages = languages
	}
}

let decoder = JSONDecoder()
let developer = try! decoder.decode(Developer.self, from:json)
developer.languages.forEach { print("""
-------
language name: \($0.name)
company name: \($0.company)
-------
""")
}

//: [Next](@next)
