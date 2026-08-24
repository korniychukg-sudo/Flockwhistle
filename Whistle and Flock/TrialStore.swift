import SwiftUI

struct TrialCard: Codable {
    var fieldId: String
    var day: Int
    var grade: String
    var total: Int
    var outrun: Double
    var lift: Double
    var fetch: Double
    var drive: Double
    var crossDrive: Double
    var shed: Double
    var pen: Double
    var seconds: Double
    var commands: Int
    var track: [Double]
}

struct MeetRecord: Codable {
    var day: Int
    var fieldId: String
    var total: Int
    var target: Int
    var met: Bool
}

struct TrialSnapshot: Codable {
    var onboarded: Bool?
    var points: Int?
    var streak: Int?
    var bestStreak: Int?
    var lastRunDay: Int?
    var cards: [String: TrialCard]?
    var meets: [MeetRecord]?
    var runs: Int?
    var whistles: Int?
    var pens: Int?
    var plateRead: [String]?
}

final class TrialStore: ObservableObject {
    @Published var onboarded = false
    @Published var points = 0
    @Published var streak = 0
    @Published var bestStreak = 0
    @Published var lastRunDay = -1
    @Published var cards: [String: TrialCard] = [:]
    @Published var meets: [MeetRecord] = []
    @Published var runs = 0
    @Published var whistles = 0
    @Published var pens = 0
    @Published var plateRead: Set<String> = []

    private let key = "whistleandflock.cards.v1"

    init() { load() }

    var liveStreak: Int {
        let today = Meets.dayIndex()
        if lastRunDay == today || lastRunDay == today - 1 { return streak }
        return 0
    }

    var rank: HandlerRank { HandlerRanks.rank(for: points) }
    var nextRank: HandlerRank? { HandlerRanks.next(for: points) }
    var rankProgress: Double {
        guard let next = nextRank else { return 1 }
        let base = rank.need
        return max(0, min(1, Double(points - base) / Double(max(1, next.need - base))))
    }

    var cardCount: Int { cards.count }
    var topGrades: Int { cards.values.filter { $0.grade == "A" }.count }
    var bestTotal: Int { cards.values.map { $0.total }.max() ?? 0 }

    func card(for id: String) -> TrialCard? { cards[id] }
    func ranToday() -> Bool { lastRunDay == Meets.dayIndex() }
    func todayMeet() -> MeetRecord? { meets.first { $0.day == Meets.dayIndex() } }

    func markOnboarded() {
        onboarded = true
        saveNow()
    }

    func markPlate(_ id: String) {
        if !plateRead.contains(id) {
            plateRead.insert(id)
            points += 6
            saveNow()
        }
    }

    func countWhistle() {
        whistles += 1
    }

    func finish(field: TrialField, result: TrialResult, card: TrialCard, meet: DayCard?) -> Bool {
        let day = Meets.dayIndex()
        runs += 1
        if result.pen > 0.8 { pens += 1 }
        points += result.points

        var improved = false
        if let existing = cards[field.id] {
            if result.total > existing.total {
                cards[field.id] = card
                improved = true
            }
        } else {
            cards[field.id] = card
            improved = true
        }

        if let m = meet, m.field.id == field.id, meets.first(where: { $0.day == day }) == nil {
            let met = result.total >= m.target
            meets.append(MeetRecord(day: day, fieldId: field.id, total: result.total,
                                    target: m.target, met: met))
            if met { points += 40 }
        }

        if lastRunDay != day {
            if lastRunDay == day - 1 { streak += 1 } else { streak = 1 }
            lastRunDay = day
            bestStreak = max(bestStreak, streak)
        }
        saveNow()
        return improved
    }

    func load() {
        guard let data = UserDefaults.standard.data(forKey: key),
              let snap = try? JSONDecoder().decode(TrialSnapshot.self, from: data) else { return }
        onboarded = snap.onboarded ?? false
        points = snap.points ?? 0
        streak = snap.streak ?? 0
        bestStreak = snap.bestStreak ?? 0
        lastRunDay = snap.lastRunDay ?? -1
        cards = snap.cards ?? [:]
        meets = snap.meets ?? []
        runs = snap.runs ?? 0
        whistles = snap.whistles ?? 0
        pens = snap.pens ?? 0
        plateRead = Set(snap.plateRead ?? [])
    }

    func saveNow() {
        let snap = TrialSnapshot(onboarded: onboarded, points: points, streak: streak,
                                 bestStreak: bestStreak, lastRunDay: lastRunDay, cards: cards,
                                 meets: meets, runs: runs, whistles: whistles, pens: pens,
                                 plateRead: Array(plateRead))
        if let data = try? JSONEncoder().encode(snap) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }
}

func flattenTrack(_ pts: [CGPoint]) -> [Double] {
    var out: [Double] = []
    for p in pts.prefix(400) {
        out.append(Double(p.x))
        out.append(Double(p.y))
    }
    return out
}

func unflattenTrack(_ raw: [Double]) -> [CGPoint] {
    var out: [CGPoint] = []
    var i = 0
    while i + 1 < raw.count {
        out.append(CGPoint(x: raw[i], y: raw[i + 1]))
        i += 2
    }
    return out
}
