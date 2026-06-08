import Foundation
import SwiftData

@Model
final class OffGridUser {
    var id: UUID
    var displayName: String
    var streakDays: Int
    var disciplineScore: Int
    var dailyAppUsageLimitMinutes: Int
    var hasHardModeEnabled: Bool
    var createdAt: Date

    init(id: UUID = UUID(), displayName: String, streakDays: Int = 0, disciplineScore: Int = 0, dailyAppUsageLimitMinutes: Int = 45, hasHardModeEnabled: Bool = true, createdAt: Date = Date()) {
        self.id = id
        self.displayName = displayName
        self.streakDays = streakDays
        self.disciplineScore = disciplineScore
        self.dailyAppUsageLimitMinutes = dailyAppUsageLimitMinutes
        self.hasHardModeEnabled = hasHardModeEnabled
        self.createdAt = createdAt
    }
}

@Model
final class SocialKey {
    var id: UUID
    var ownerUserID: UUID
    var guardianUserID: UUID?
    var guardianDisplayName: String
    var statusRawValue: String
    var tokenHash: String?
    var expiresAt: Date
    var guardianPointCost: Int
    var consumedAt: Date?

    var status: SocialKeyStatus {
        get { SocialKeyStatus(rawValue: statusRawValue) ?? .escrowed }
        set { statusRawValue = newValue.rawValue }
    }

    init(id: UUID = UUID(), ownerUserID: UUID, guardianUserID: UUID? = nil, guardianDisplayName: String, status: SocialKeyStatus = .escrowed, tokenHash: String? = nil, expiresAt: Date, guardianPointCost: Int = 12, consumedAt: Date? = nil) {
        self.id = id
        self.ownerUserID = ownerUserID
        self.guardianUserID = guardianUserID
        self.guardianDisplayName = guardianDisplayName
        self.statusRawValue = status.rawValue
        self.tokenHash = tokenHash
        self.expiresAt = expiresAt
        self.guardianPointCost = guardianPointCost
        self.consumedAt = consumedAt
    }
}

@Model
final class RestrictionGoal {
    var id: UUID
    var title: String
    var categoryRawValue: String
    var dailyQuotaMinutes: Int
    var hardModeThresholdMinutes: Int
    var startsAt: Date
    var endsAt: Date
    var isActive: Bool

    var category: RestrictedCategory {
        get { RestrictedCategory(rawValue: categoryRawValue) ?? .social }
        set { categoryRawValue = newValue.rawValue }
    }

    init(id: UUID = UUID(), title: String, category: RestrictedCategory, dailyQuotaMinutes: Int, hardModeThresholdMinutes: Int, startsAt: Date, endsAt: Date, isActive: Bool = true) {
        self.id = id
        self.title = title
        self.categoryRawValue = category.rawValue
        self.dailyQuotaMinutes = dailyQuotaMinutes
        self.hardModeThresholdMinutes = hardModeThresholdMinutes
        self.startsAt = startsAt
        self.endsAt = endsAt
        self.isActive = isActive
    }
}

@Model
final class AvatarProfile {
    var id: UUID
    var userID: UUID
    var energyLevel: Int
    var lastSleepMinutes: Int
    var offlineMinutesToday: Int
    var cosmeticRarityRawValue: String
    var unlockedCosmetics: [String]

    var cosmeticRarity: CosmeticRarity {
        get { CosmeticRarity(rawValue: cosmeticRarityRawValue) ?? .common }
        set { cosmeticRarityRawValue = newValue.rawValue }
    }

    init(id: UUID = UUID(), userID: UUID, energyLevel: Int = 50, lastSleepMinutes: Int = 0, offlineMinutesToday: Int = 0, cosmeticRarity: CosmeticRarity = .common, unlockedCosmetics: [String] = []) {
        self.id = id
        self.userID = userID
        self.energyLevel = energyLevel
        self.lastSleepMinutes = lastSleepMinutes
        self.offlineMinutesToday = offlineMinutesToday
        self.cosmeticRarityRawValue = cosmeticRarity.rawValue
        self.unlockedCosmetics = unlockedCosmetics
    }
}

enum SocialKeyStatus: String, Codable, CaseIterable {
    case escrowed
    case requested
    case approved
    case refused
    case consumed
    case expired
}

enum RestrictedCategory: String, Codable, CaseIterable {
    case social
    case entertainment
    case games
    case websites
}

enum CosmeticRarity: String, Codable, CaseIterable {
    case common
    case uncommon
    case rare
    case epic
    case legendary
}
