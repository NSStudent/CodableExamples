//: [Previous](@previous)
//: # Basic Examples
import Foundation

let json = """
[
  {
    "id": 1,
    "company": "Apple",
    "language_name": "Swift",
  },
  {
    "id": 2,
    "company": "JetBrains",
    "language_name": "Kotlin",
  },
  {
    "id": 2,
    "company": "Google",
    "language_name": "Go",
  }
]
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

let decoder = JSONDecoder()
//decoder.keyDecodingStrategy = .convertFromSnakeCase
let languageArray = try! decoder.decode([Language].self, from:json)

let encoder = JSONEncoder()
encoder.outputFormatting = .prettyPrinted
let jsonData = try! encoder.encode(languageArray)
print(String(data: jsonData, encoding: .utf8)!)

//: [Next](@next)
