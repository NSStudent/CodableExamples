//: [Previous](@previous)
//: # Indeterminate types
import Foundation

//: This is the data response from the API
let json = """
[
  {
    "alias": "Personal Account",
    "balance": 3000,
    "account_number": "4043 5021 23 1231231231",
  },
  {
    "alias": "Family Account",
    "balance": 2000,
    "account_number": "4043 5021 22 1111111111",
  },
  {
    "alias": "personal debit card",
    "is_credit_card": false,
    "account_id": "4043 5021 22 1111111111"
  }
]
""".data(using: String.Encoding.utf8)!

struct Account: Codable {
	let alias: String
	let balance: Int
	let identifier: String
	
	private enum CodingKeys: String, CodingKey {
		case alias
		case balance
		case identifier = "account_number"
	}
}

struct Card: Codable {
	let alias: String
	let isCredit: Bool
	let AccountId: String
	
	private enum CodingKeys: String, CodingKey {
		case alias
		case isCredit = "is_credit_card"
		case AccountId = "account_id"
	}
}

enum Product {
	case account(Account)
	case card(Card)
}

extension Product: Decodable {
	init(from decoder: Decoder) throws {
		if let account = try? Account(from: decoder) {
			self = .account(account)
		} else if let card = try? Card(from: decoder) {
			self = .card(card)
		} else {
			let context = DecodingError.Context(codingPath:decoder.codingPath,
												debugDescription:"Cannot decode Account or Card")
			throw DecodingError.dataCorrupted(context)
		}
	}
}

let decoder = JSONDecoder()
do {
	let ProductArray = try decoder.decode([Product].self, from:json)
	ProductArray.forEach {
		switch $0 {
		case .account(let account):
			print("Account with alias: \(account.alias)")
		case .card(let card):
			print("Card with alias: \(card.alias)")
		}
	}
} catch {
	print(error.localizedDescription)
}
