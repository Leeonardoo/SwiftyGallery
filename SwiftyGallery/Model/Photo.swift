//
//  Photo.swift
//  SwiftyGallery
//
//  Created by Leonardo de Oliveira on 07/12/23.
//

import Foundation
import MetaCodable

// Tags?
struct Photo: Decodable, Hashable {
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

struct PhotoUrls: Decodable, Hashable {
    let raw: String
    let full: String
    let regular: String
    let small: String
    let thumb: String
    let smallS3: String
}

@Codable
struct PhotoLinks: Hashable {
    @CodedAt("self")
    let selfLink: String
    let html: String
    let download: String
    let downloadLocation: String
}

struct User: Decodable, Hashable {
    let id: String
    let updatedAt: Date
    let name: String
    let username: String
    let firstName: String?
    let lastName: String?
    let twitterUsername: String?
    let portifolioUrl: String?
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
struct UserLinks: Hashable {
    @CodedAt("self")
    let selfLink: String
    let html: String
    let photos: String
    let likes: String
    let portfolio: String
    let following: String
    let followers: String
}

struct UserImage: Decodable, Hashable {
    let small: String
    let medium: String
    let large: String
}

struct UserSocial: Decodable, Hashable {
    let instagramUsername: String?
    let portfolioUrl: String?
    let twitterUsername: String?
    let paypalEmail: String?
}

#if DEBUG
let demoPhoto = Photo(
    id: "1",
    slug: "test",
    createdAt: Date(),
    updatedAt: Date(),
    promotedAt: nil,
    width: 900,
    height: 900,
    color: "#000000",
    blurHash: nil,
    description: "Some description here",
    altDescription: "Some alt description here",
    urls: PhotoUrls(
        raw: "https://images.unsplash.com/photo-1695515115475-dc5495581ea8?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3wxMjA3fDB8MXxhbGx8NDJ8fHx8fHwyfHwxNjk1OTQwMzM4fA&ixlib=rb-4.0.3&q=80&w=400",
        full: "https://images.unsplash.com/photo-1695515115475-dc5495581ea8?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3wxMjA3fDB8MXxhbGx8NDJ8fHx8fHwyfHwxNjk1OTQwMzM4fA&ixlib=rb-4.0.3&q=80&w=400",
        regular: "https://images.unsplash.com/photo-1695515115475-dc5495581ea8?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3wxMjA3fDB8MXxhbGx8NDJ8fHx8fHwyfHwxNjk1OTQwMzM4fA&ixlib=rb-4.0.3&q=80&w=400",
        small: "https://images.unsplash.com/photo-1695515115475-dc5495581ea8?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3wxMjA3fDB8MXxhbGx8NDJ8fHx8fHwyfHwxNjk1OTQwMzM4fA&ixlib=rb-4.0.3&q=80&w=400",
        thumb: "https://images.unsplash.com/photo-1695515115475-dc5495581ea8?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3wxMjA3fDB8MXxhbGx8NDJ8fHx8fHwyfHwxNjk1OTQwMzM4fA&ixlib=rb-4.0.3&q=80&w=400",
        smallS3: "https://images.unsplash.com/photo-1695515115475-dc5495581ea8?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3wxMjA3fDB8MXxhbGx8NDJ8fHx8fHwyfHwxNjk1OTQwMzM4fA&ixlib=rb-4.0.3&q=80&w=400"
    ),
    links: PhotoLinks(
        selfLink: "https://images.unsplash.com/photo-1695515115475-dc5495581ea8?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3wxMjA3fDB8MXxhbGx8NDJ8fHx8fHwyfHwxNjk1OTQwMzM4fA&ixlib=rb-4.0.3&q=80&w=400", 
        html: "https://images.unsplash.com/photo-1695515115475-dc5495581ea8?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3wxMjA3fDB8MXxhbGx8NDJ8fHx8fHwyfHwxNjk1OTQwMzM4fA&ixlib=rb-4.0.3&q=80&w=400",
        download: "https://images.unsplash.com/photo-1695515115475-dc5495581ea8?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3wxMjA3fDB8MXxhbGx8NDJ8fHx8fHwyfHwxNjk1OTQwMzM4fA&ixlib=rb-4.0.3&q=80&w=400",
        downloadLocation: "https://images.unsplash.com/photo-1695515115475-dc5495581ea8?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3wxMjA3fDB8MXxhbGx8NDJ8fHx8fHwyfHwxNjk1OTQwMzM4fA&ixlib=rb-4.0.3&q=80&w=400"
    ),
    likes: 55,
    premium: false,
    plus: false,
    user: User(
        id: "2",
        updatedAt: Date(),
        name: "Karsten Winegeart",
        username: "Karsten Winegeart",
        firstName: "Karsten",
        lastName: "Winegeart",
        twitterUsername: "test",
        portifolioUrl: "https://karsten.photos",
        bio: "Some bio here",
        location: "Portland, OR",
        links: UserLinks(
            selfLink: "https://images.unsplash.com/photo-1494790108377-be9c29b29330?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3wxMjA3fDB8MXxzZWFyY2h8M3x8cHJvZmlsZXxlbnwwfHx8fDE2OTYyMDE2NzV8MA&ixlib=rb-4.0.3&q=80&w=400",
            html: "https://images.unsplash.com/photo-1494790108377-be9c29b29330?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3wxMjA3fDB8MXxzZWFyY2h8M3x8cHJvZmlsZXxlbnwwfHx8fDE2OTYyMDE2NzV8MA&ixlib=rb-4.0.3&q=80&w=400",
            photos: "https://images.unsplash.com/photo-1494790108377-be9c29b29330?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3wxMjA3fDB8MXxzZWFyY2h8M3x8cHJvZmlsZXxlbnwwfHx8fDE2OTYyMDE2NzV8MA&ixlib=rb-4.0.3&q=80&w=400",
            likes: "https://images.unsplash.com/photo-1494790108377-be9c29b29330?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3wxMjA3fDB8MXxzZWFyY2h8M3x8cHJvZmlsZXxlbnwwfHx8fDE2OTYyMDE2NzV8MA&ixlib=rb-4.0.3&q=80&w=400",
            portfolio: "https://images.unsplash.com/photo-1494790108377-be9c29b29330?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3wxMjA3fDB8MXxzZWFyY2h8M3x8cHJvZmlsZXxlbnwwfHx8fDE2OTYyMDE2NzV8MA&ixlib=rb-4.0.3&q=80&w=400",
            following: "https://images.unsplash.com/photo-1494790108377-be9c29b29330?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3wxMjA3fDB8MXxzZWFyY2h8M3x8cHJvZmlsZXxlbnwwfHx8fDE2OTYyMDE2NzV8MA&ixlib=rb-4.0.3&q=80&w=400",
            followers: "https://images.unsplash.com/photo-1494790108377-be9c29b29330?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3wxMjA3fDB8MXxzZWFyY2h8M3x8cHJvZmlsZXxlbnwwfHx8fDE2OTYyMDE2NzV8MA&ixlib=rb-4.0.3&q=80&w=400"
        ),
        profileImage: UserImage(
            small: "https://images.unsplash.com/photo-1494790108377-be9c29b29330?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3wxMjA3fDB8MXxzZWFyY2h8M3x8cHJvZmlsZXxlbnwwfHx8fDE2OTYyMDE2NzV8MA&ixlib=rb-4.0.3&q=80&w=400",
            medium: "https://images.unsplash.com/photo-1494790108377-be9c29b29330?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3wxMjA3fDB8MXxzZWFyY2h8M3x8cHJvZmlsZXxlbnwwfHx8fDE2OTYyMDE2NzV8MA&ixlib=rb-4.0.3&q=80&w=400",
            large: "https://images.unsplash.com/photo-1494790108377-be9c29b29330?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3wxMjA3fDB8MXxzZWFyY2h8M3x8cHJvZmlsZXxlbnwwfHx8fDE2OTYyMDE2NzV8MA&ixlib=rb-4.0.3&q=80&w=400"
        ),
        instagramUsername: "test",
        totalCollections: 2,
        totalLikes: 1230,
        totalPhotos: 12,
        forHire: false,
        social: UserSocial(
            instagramUsername: "test",
            portfolioUrl: "https://unsplash.com",
            twitterUsername: "test",
            paypalEmail: "test@example.com"
        )
    )
)
#endif
