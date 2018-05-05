//: # Basic Examples
import Foundation

let json = """
{
  "identifier": 1,
  "company": "Apple",
  "name": "Swift",
}
""".data(using: String.Encoding.utf8)!


struct Language: Codable {
	let identifier: Int
	let company: String
	let name: String
	
	private enum CodingKeys: String, CodingKey {
		case identifier
		case company
		case name
	}
	
	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		self.identifier = try container.decode(Int.self, forKey: .identifier)
		self.company = try container.decode(String.self, forKey: .company)
		self.name = try container.decode(String.self, forKey: .name)
	}
	
	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(self.identifier, forKey: .identifier)
		try container.encode(self.company, forKey: .company)
		try container.encode(self.name, forKey: .name)
	}
	
}

let decoder = JSONDecoder()
let language = try! decoder.decode(Language.self, from:json)

let encoder = JSONEncoder()
encoder.outputFormatting = .prettyPrinted
let jsonData = try! encoder.encode(language)
print(String(data: jsonData, encoding: .utf8)!)
//: [Next](@next)
