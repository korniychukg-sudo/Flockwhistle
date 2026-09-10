import SwiftUI

struct CraftEntry {
    let id: String
    let kicker: String
    let title: String
    let sub: String
    let summary: String
    var plate: String { "craft_" + id }
}

struct ToolEntry {
    let id: String
    let name: String
    let note: String
    var plate: String { "kit_" + id }
}

enum CraftShelf {
    static let entries: [CraftEntry] = shelfA + shelfB

    private static let shelfA: [CraftEntry] = [
        CraftEntry(id: "outrun", kicker: "Plate I", title: "The outrun",
                   sub: "Wide enough that the sheep never see the dog coming",
                   summary: "The dog leaves the handler, opens out as it runs and comes in behind the sheep at the top. A dog that changes sides has crossed its course, and at a trial that is the end of the run."),
        CraftEntry(id: "lift", kicker: "Plate II", title: "The lift",
                   sub: "The ten seconds that decide everything after",
                   summary: "At the top the dog stops and lets the sheep notice it. Sheep that lift calmly walk; sheep that are startled run, and running sheep cannot be steered."),
        CraftEntry(id: "fetch", kicker: "Plate III", title: "The fetch",
                   sub: "A straight line, through the gates, round the post",
                   summary: "The judge watches the line, not the gates alone. Sheep wrenched back through the gates lose more than sheep that miss them on a straight line."),
        CraftEntry(id: "drive", kicker: "Plate IV", title: "Drive and cross-drive",
                   sub: "Pushing sheep away from the one thing they want",
                   summary: "Sheep want to come back to the handler. The drive holds a line directly against that wish for two hundred yards, by many small flanks rather than two big ones."),
        CraftEntry(id: "shed", kicker: "Plate V", title: "The shed",
                   sub: "Splitting a flock in a marked ring",
                   summary: "The handler opens a gap and only then calls the dog through it. Everything a flock does is designed to prevent exactly this."),
        CraftEntry(id: "pen", kicker: "Plate VI", title: "The pen",
                   sub: "Six feet of rope and no room for hurry",
                   summary: "The handler holds the gate rope and may not let go. The dog walks them in a step at a time, and most pens are lost in the last three feet."),
    ]

    private static let shelfB: [CraftEntry] = [
        CraftEntry(id: "whistles", kicker: "Plate VII", title: "The whistles",
                   sub: "Six shapes that carry a mile",
                   summary: "The dog learns the shape of the sound, not the pitch: rising, falling, two notes, a long steady tone. A voice is lost at two hundred yards; a whistle is not."),
        CraftEntry(id: "flight", kicker: "Plate VIII", title: "Flight zone and balance",
                   sub: "Why a dog standing still moves a flock",
                   summary: "Step inside the flight zone and the animal moves; stand on its edge and it watches. The point of balance is at the shoulder, and a yard either side turns the whole flock."),
        CraftEntry(id: "breeds", kicker: "Plate IX", title: "How different sheep move",
                   sub: "Six breeds and six problems",
                   summary: "Hill breeds lift at three hundred yards and keep going; heavy breeds stand and look; horned ewes face a dog rather than turn from it."),
        CraftEntry(id: "young", kicker: "Plate X", title: "The young dog",
                   sub: "Two years of doing almost nothing",
                   summary: "Stop first, on a whistle, every time. Then three quiet ewes in a small paddock, because everything learned badly there is learned badly for life."),
        CraftEntry(id: "card", kicker: "Plate XI", title: "The judge's card",
                   sub: "A hundred points, and every one of them taken away",
                   summary: "Outrun twenty, lift ten, fetch twenty, drive thirty, shed ten, pen ten, fifteen minutes. The judge starts at a hundred and deducts; nothing is ever added."),
        CraftEntry(id: "year", kicker: "Plate XII", title: "The shepherd's year",
                   sub: "Twelve months on the same hill",
                   summary: "Tups out in November, lambing in April, marking and clipping through summer, and three or four full gathers a year across ground no vehicle can reach."),
    ]

    static let kit: [ToolEntry] = [
        ToolEntry(id: "whistle", name: "The shepherd's whistle",
                  note: "A folded plate of tin or brass held between teeth and tongue. Weeks to make a note at all, years to make six at will."),
        ToolEntry(id: "crook", name: "The crook",
                  note: "Hazel shank, horn head, used far more as a third leg on a wet hill than for catching anything."),
        ToolEntry(id: "collar", name: "Collar and lead",
                  note: "A dog that will not walk quietly past sheep on a lead is not ready to work them off one."),
        ToolEntry(id: "hurdle", name: "Hurdles and the pen",
                  note: "Six light hurdles make a pen anywhere. At a trial the mouth is nine feet and the gate swings on a rope the handler may not release."),
        ToolEntry(id: "tally", name: "The tally stick",
                  note: "Yan, tan, tethera, methera, pimp. Sheep counted in scores in a dialect older than English, with a notch for every score."),
        ToolEntry(id: "card", name: "The judge's card and pencil",
                  note: "Deductions written as they happen, because nobody can reconstruct a run from memory afterwards."),
    ]
}
