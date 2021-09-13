//
//  model.swift
//  searchImages
//
//  Created by Decagon on 12/09/2021.
//

import Foundation

struct APIResponse: Codable {
  let total: Int
  let total_pages: Int
  let results: [Result]
}

struct Result: Codable {
  let id: String
  let urls: URLS
}

struct URLS: Codable {
  let regular: String
}
