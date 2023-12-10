//
//  Photo.swift
//  SwiftyGallery
//
//  Created by Leonardo de Oliveira on 07/12/23.
//

import Foundation
import MetaCodable
import HelperCoders

// Tags?
struct Photo: Decodable {
    let id: String
    let slug: String
    let createdAt: Date
    let updatedAt: Date
    let promotedAt: Date?
    let width: Int
    let height: Int
    let color: String? //Hex
    let blurHash: String?
    let description: String?
    let altDescription: String?
    let urls: PhotoUrls
    let links: PhotoLinks
    let likes: Int
    let premium: Bool
    let plus: Bool
    let user: User
}

struct PhotoUrls: Decodable {
    let raw: URL
    let full: URL
    let regular: URL
    let small: URL
    let thumb: URL
    let smallS3: URL
}

@Codable
struct PhotoLinks {
    @CodedAt("self")
    let selfLink: URL
    let html: URL
    let download: URL
    let downloadLocation: URL
}

struct User: Decodable {
    let id: String
    let updatedAt: Date
    let name: String
    let username: String
    let firstName: String?
    let lastName: String?
    let twitterUsername: String?
    let portifolioUrl: URL?
    let bio: String?
    let location: String?
    let links: UserLinks
    let profileImage: UserImage
    let instagramUsername: String?
    let totalCollections: Int
    let totalLikes: Int
    let totalPhotos: Int
    let forHire: Bool
    let social: UserSocial
}

@Codable
struct UserLinks {
    @CodedAt("self")
    let selfLink: URL
    let html: URL
    let photos: URL
    let likes: URL
    let portfolio: URL
    let following: URL
    let followers: URL
}

struct UserImage: Decodable {
    let small: URL
    let medium: URL
    let large: URL
}

struct UserSocial: Decodable {
    let instagramUsername: String?
    let portfolioUrl: URL?
    let twitterUsername: String?
    let paypalEmail: String?
}
