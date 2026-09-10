import SwiftUI

struct TrialField {
    let id: String
    let name: String
    let place: String
    let terrain: String
    let breed: String
    let sheepCount: Int
    let kicker: String
    let blurb: String
    let difficulty: Int
    let flightZone: Double
    let sheepSpeed: Double
    let stubborn: Double

    var plate: String { "field_" + id }
    var config: FlockField {
        FlockField(flightZone: flightZone, speed: sheepSpeed, stubborn: stubborn)
    }
}

enum FieldBook {
    static let all: [TrialField] = listA + listB + listC

    static func field(_ id: String) -> TrialField? { all.first { $0.id == id } }

    private static let listA: [TrialField] = [
        TrialField(id: "bowder_fell", name: "Bowder Fell", place: "Cumbria",
                   terrain: "Open fell, rising ground", breed: "Herdwick", sheepCount: 5,
                   kicker: "Field I",
                   blurb: "Heavy sheep that stand and look at a dog. Pressure has to be held longer here and taken off the moment they turn.",
                   difficulty: 1, flightZone: 0.15, sheepSpeed: 0.085, stubborn: 0.75),
        TrialField(id: "nine_standards", name: "Nine Standards", place: "Yorkshire Dales",
                   terrain: "Limestone pasture", breed: "Swaledale", sheepCount: 5,
                   kicker: "Field II",
                   blurb: "Hard hill ewes on short grass. They walk well if the dog stays off them and scatter the moment it does not.",
                   difficulty: 2, flightZone: 0.17, sheepSpeed: 0.10, stubborn: 0.5),
        TrialField(id: "cwm_hirwaun", name: "Cwm Hirwaun", place: "Brecon",
                   terrain: "Steep valley side", breed: "Welsh Mountain", sheepCount: 5,
                   kicker: "Field III",
                   blurb: "Light, quick and honest. They answer the smallest movement of the dog, which is a gift and a trap.",
                   difficulty: 3, flightZone: 0.20, sheepSpeed: 0.125, stubborn: 0.3),
        TrialField(id: "glenfarg_brae", name: "Glenfarg Brae", place: "Perthshire",
                   terrain: "Rolling brae", breed: "Scottish Blackface", sheepCount: 6,
                   kicker: "Field IV",
                   blurb: "Six head on ground that falls away from the post, so the fetch line is never where it looks.",
                   difficulty: 3, flightZone: 0.18, sheepSpeed: 0.11, stubborn: 0.45),
        TrialField(id: "rhinog_bach", name: "Rhinog Bach", place: "Snowdonia",
                   terrain: "Boulder and heather", breed: "Welsh Mountain", sheepCount: 5,
                   kicker: "Field V",
                   blurb: "Broken ground where a dog vanishes for whole seconds. Whistle to where it should be, not where it was.",
                   difficulty: 4, flightZone: 0.21, sheepSpeed: 0.13, stubborn: 0.3),
        TrialField(id: "kirkstone_intake", name: "Kirkstone Intake", place: "Lakeland",
                   terrain: "Walled intake", breed: "Herdwick", sheepCount: 5,
                   kicker: "Field VI",
                   blurb: "Walls on two sides, which helps the drive and ruins the shed if you let them get to the stones.",
                   difficulty: 2, flightZone: 0.15, sheepSpeed: 0.09, stubborn: 0.7),
        TrialField(id: "blacka_moor", name: "Blacka Moor", place: "Peak District",
                   terrain: "Heather moor", breed: "Lonk", sheepCount: 5,
                   kicker: "Field VII",
                   blurb: "Big-framed moorland ewes. Slow to start and hard to turn once they are going.",
                   difficulty: 3, flightZone: 0.16, sheepSpeed: 0.095, stubborn: 0.68),
        TrialField(id: "slieve_rushen", name: "Slieve Rushen", place: "Fermanagh",
                   terrain: "Rushy hill", breed: "Cheviot", sheepCount: 5,
                   kicker: "Field VIII",
                   blurb: "Cheviots go early and go far. The outrun must be wide or there will be nothing left to fetch.",
                   difficulty: 4, flightZone: 0.23, sheepSpeed: 0.14, stubborn: 0.25),
    ]

    private static let listB: [TrialField] = [
        TrialField(id: "dunveth_downs", name: "Dunveth Downs", place: "Cornwall",
                   terrain: "Coastal down", breed: "Dartmoor Greyface", sheepCount: 6,
                   kicker: "Field IX",
                   blurb: "Steady lowland sheep in a sea wind that takes half the whistle away with it.",
                   difficulty: 2, flightZone: 0.16, sheepSpeed: 0.10, stubborn: 0.5),
        TrialField(id: "sourhope_head", name: "Sourhope Head", place: "Cheviots",
                   terrain: "Long grass slope", breed: "Cheviot", sheepCount: 5,
                   kicker: "Field X",
                   blurb: "A long slope where the sheep can see the pen from the top and have decided about it already.",
                   difficulty: 4, flightZone: 0.22, sheepSpeed: 0.135, stubborn: 0.3),
        TrialField(id: "gowbarrow", name: "Gowbarrow Park", place: "Ullswater",
                   terrain: "Parkland and bracken", breed: "Rough Fell", sheepCount: 5,
                   kicker: "Field XI",
                   blurb: "Park sheep used to people, so they let a dog close and then resent it.",
                   difficulty: 2, flightZone: 0.13, sheepSpeed: 0.095, stubborn: 0.6),
        TrialField(id: "trawsfynydd", name: "Trawsfynydd Moor", place: "Gwynedd",
                   terrain: "Wet moor", breed: "Welsh Mountain", sheepCount: 6,
                   kicker: "Field XII",
                   blurb: "Soft going, so everything is slower than it looks and the dog tires before the sheep do.",
                   difficulty: 3, flightZone: 0.19, sheepSpeed: 0.115, stubborn: 0.35),
        TrialField(id: "wanlockhead", name: "Wanlockhead", place: "Lowther Hills",
                   terrain: "High bare hill", breed: "Scottish Blackface", sheepCount: 5,
                   kicker: "Field XIII",
                   blurb: "Nothing to hide behind and a wind that eats a whistle. The dog will be out of hearing at the top.",
                   difficulty: 5, flightZone: 0.22, sheepSpeed: 0.13, stubborn: 0.32),
        TrialField(id: "carn_dubh", name: "Carn Dubh", place: "Aberdeenshire",
                   terrain: "Granite and rush", breed: "Scottish Blackface", sheepCount: 5,
                   kicker: "Field XIV",
                   blurb: "Hard sheep on hard ground, and a shed ring that sits on a slope.",
                   difficulty: 4, flightZone: 0.20, sheepSpeed: 0.125, stubborn: 0.4),
        TrialField(id: "longmynd", name: "Longmynd Hollow", place: "Shropshire",
                   terrain: "Dry heath", breed: "Beulah Speckled Face", sheepCount: 5,
                   kicker: "Field XV",
                   blurb: "Even-tempered sheep in a hollow where the handler cannot see the far gate properly.",
                   difficulty: 3, flightZone: 0.17, sheepSpeed: 0.105, stubborn: 0.45),
        TrialField(id: "grasslees", name: "Grasslees Burn", place: "Redesdale",
                   terrain: "Burn and haugh", breed: "Cheviot", sheepCount: 6,
                   kicker: "Field XVI",
                   blurb: "A burn along one side that the sheep will not cross and will follow all day.",
                   difficulty: 4, flightZone: 0.21, sheepSpeed: 0.13, stubborn: 0.3),
    ]

    private static let listC: [TrialField] = [
        TrialField(id: "loch_skerrow", name: "Loch Skerrow", place: "Galloway",
                   terrain: "Bog and knowes", breed: "Blackface", sheepCount: 5,
                   kicker: "Field XVII",
                   blurb: "Knowes that put the sheep out of sight of the dog at exactly the wrong moment.",
                   difficulty: 4, flightZone: 0.19, sheepSpeed: 0.12, stubborn: 0.4),
        TrialField(id: "hafod_y_llan", name: "Hafod y Llan", place: "Nant Gwynant",
                   terrain: "Mountain ffridd", breed: "Welsh Mountain", sheepCount: 6,
                   kicker: "Field XVIII",
                   blurb: "Hefted ewes off the mountain who know exactly where home is and will take any chance to start for it.",
                   difficulty: 5, flightZone: 0.23, sheepSpeed: 0.14, stubborn: 0.28),
        TrialField(id: "whitfield_fell", name: "Whitfield Fell", place: "Pennines",
                   terrain: "Rough grazing", breed: "Swaledale", sheepCount: 5,
                   kicker: "Field XIX",
                   blurb: "The nursery field: quiet sheep, a short course, and nothing to catch out a young dog.",
                   difficulty: 1, flightZone: 0.14, sheepSpeed: 0.085, stubborn: 0.55),
        TrialField(id: "eskdale_green", name: "Eskdale Green", place: "Cumbria",
                   terrain: "Valley meadow", breed: "Herdwick", sheepCount: 5,
                   kicker: "Field XX",
                   blurb: "Flat meadow, heavy sheep, and a pen against the wall where they can see no way out.",
                   difficulty: 2, flightZone: 0.15, sheepSpeed: 0.09, stubborn: 0.72),
        TrialField(id: "achnasheen", name: "Achnasheen Bank", place: "Wester Ross",
                   terrain: "Peat hag", breed: "Blackface", sheepCount: 6,
                   kicker: "Field XXI",
                   blurb: "Hags deep enough to swallow a dog. There is a point where whistling stops helping.",
                   difficulty: 5, flightZone: 0.21, sheepSpeed: 0.13, stubborn: 0.35),
        TrialField(id: "cregneash", name: "Cregneash Common", place: "Isle of Man",
                   terrain: "Sea-blown common", breed: "Manx Loaghtan", sheepCount: 5,
                   kicker: "Field XXII",
                   blurb: "Horned sheep that face a dog instead of turning from it. Give ground once and they will test you all day.",
                   difficulty: 5, flightZone: 0.13, sheepSpeed: 0.105, stubborn: 0.85),
        TrialField(id: "foel_grach", name: "Foel Grach Pastures", place: "Carneddau",
                   terrain: "High pasture", breed: "Welsh Mountain", sheepCount: 6,
                   kicker: "Field XXIII",
                   blurb: "High, open and honest ground: the best place there is to find out what a dog really knows.",
                   difficulty: 3, flightZone: 0.19, sheepSpeed: 0.12, stubborn: 0.35),
        TrialField(id: "hound_tor", name: "Hound Tor Down", place: "Dartmoor",
                   terrain: "Granite clitter", breed: "Dartmoor Greyface", sheepCount: 5,
                   kicker: "Field XXIV",
                   blurb: "Stone everywhere and a judge who has seen everything. A dull-looking run wins here.",
                   difficulty: 4, flightZone: 0.18, sheepSpeed: 0.115, stubborn: 0.45),
    ]
}

struct HandlerRank {
    let name: String
    let need: Int
    let note: String
}

enum HandlerRanks {
    static let ladder: [HandlerRank] = [
        HandlerRank(name: "Pup at Heel", need: 0,
                    note: "You hold the gate, carry the crook and watch. Nobody lets you whistle yet."),
        HandlerRank(name: "Nursery Handler", need: 460,
                    note: "A young dog and a short course in winter, and everything still to learn."),
        HandlerRank(name: "Open Handler", need: 1500,
                    note: "You enter open trials and are not embarrassed by the card afterwards."),
        HandlerRank(name: "Shepherd", need: 3400,
                    note: "The flock is yours, the gathers are yours, and the trials are practice for the work."),
        HandlerRank(name: "Champion", need: 6800,
                    note: "Your name is on the shield and other handlers watch which side you send the dog."),
    ]

    static func rank(for points: Int) -> HandlerRank {
        var current = ladder[0]
        for r in ladder where points >= r.need { current = r }
        return current
    }

    static func next(for points: Int) -> HandlerRank? { ladder.first { $0.need > points } }
}

struct DayCard {
    let field: TrialField
    let title: String
    let note: String
    let target: Int
}

enum Meets {
    static let epoch: TimeInterval = 1_767_225_600

    static func dayIndex(_ date: Date = Date()) -> Int {
        max(0, Int((date.timeIntervalSince1970 - epoch) / 86400))
    }

    static func forDay(_ day: Int) -> DayCard {
        var rng = Roll(UInt64(day &* 2_654_435_761 &+ 5501))
        let field = FieldBook.all[rng.index(FieldBook.all.count)]
        let titles = ["The local trial, and half the valley watching",
                      "A nursery meet in a cold wind",
                      "The society's open, entries closed at forty",
                      "A charity trial on borrowed ground",
                      "The qualifier, and two places going",
                      "An evening trial after the hay",
                      "The shepherds' meet, judged by a man who does not smile",
                      "A practice run before the season"]
        let notes = ["Take your time on the outrun. Nobody was ever docked for going wide.",
                     "The sheep have been run twice already today and they know the course.",
                     "The judge is watching the lines, not the gates.",
                     "Wind from the west: your whistle will not carry to the top.",
                     "One dog before you took a grip. The sheep are unsettled."]
        let target = [52, 60, 68, 74, 82][rng.index(5)]
        return DayCard(field: field, title: titles[rng.index(titles.count)],
                       note: notes[rng.index(notes.count)], target: target)
    }
}
