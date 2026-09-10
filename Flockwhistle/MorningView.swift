import SwiftUI

struct MorningView: View {
    @EnvironmentObject var store: TrialStore
    @State private var openTrial = false
    @State private var openDrill = false
    @State private var openPlate: String?
    @State private var plateTitle = ""

    private var day: Int { Meets.dayIndex() }
    private var meet: DayCard { Meets.forDay(day) }
    private var done: MeetRecord? { store.todayMeet() }
    private var drillField: TrialField {
        FieldBook.all[(day * 5 + store.drills * 3) % FieldBook.all.count]
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 15) {
                header
                RiseIn(index: 0) { HillScene(field: meet.field) }
                RiseIn(index: 1) { meetCard }
                RiseIn(index: 2) { flockCard }
                RiseIn(index: 3) { drillCard }
                RiseIn(index: 4) { standingCard }
                RiseIn(index: 5) { boardCard }
                RiseIn(index: 6) { readingCard }
                FlockPrivacyRow()
                Color.clear.frame(height: 12)
            }
            .padding(.horizontal, Pitch.gutter)
            .padding(.top, 8)
            .centreColumn()
        }
        .hillPage()
        .navigationBarHidden(true)
        .fullScreenCover(isPresented: $openTrial) {
            TrialView(field: meet.field, meet: meet) { openTrial = false }
                .environmentObject(store)
        }
        .fullScreenCover(isPresented: $openDrill) {
            TrialView(field: drillField, meet: nil, drill: true) { openDrill = false }
                .environmentObject(store)
        }
        .sheet(isPresented: Binding(get: { openPlate != nil },
                                    set: { if !$0 { openPlate = nil } })) {
            if let plate = openPlate {
                PlateSheetView(name: plate, title: plateTitle) { openPlate = nil }
            }
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 3) {
            Text("THE YARD").font(Slate.title(11)).tracking(3.2).foregroundColor(Hill.brass)
            Text(HillLight.hue(for: HillLight.nowHour).label)
                .font(Slate.title(24)).foregroundColor(Hill.canvas)
            Text("Day \(day) with the dog · \(store.rank.name)")
                .font(Slate.italic(14)).foregroundColor(Hill.canvas.opacity(0.72))
        }
    }

    private var meetCard: some View {
        CanvasCard {
            VStack(alignment: .leading, spacing: 11) {
                FieldHead(title: "Today's trial", note: meet.title)
                Text(meet.note).font(Slate.body(15)).foregroundColor(Hill.inkSoft)
                    .fixedSize(horizontal: false, vertical: true)
                HStack(spacing: 12) {
                    FieldPlate(name: meet.field.plate, height: 128).frame(width: 100)
                    VStack(alignment: .leading, spacing: 4) {
                        Text(meet.field.name).font(Slate.title(17)).foregroundColor(Hill.ink)
                        Text("\(meet.field.place) · \(meet.field.terrain)")
                            .font(Slate.italic(12)).foregroundColor(Hill.inkPale)
                        Text("\(meet.field.breed) · \(meet.field.sheepCount) head")
                            .font(Slate.body(12)).foregroundColor(Hill.inkSoft)
                        Text("Placings from \(meet.target) points.")
                            .font(Slate.body(12)).foregroundColor(Hill.bracken)
                    }
                    Spacer(minLength: 0)
                }
                if let d = done {
                    CallBanner(title: d.met ? "You were in the placings" : "Out of the placings",
                               detail: "You scored \(d.total) against \(d.target). The field is open if you want another run.",
                               tint: d.met ? Hill.moss : Hill.bracken)
                    GateButton(title: "Run it again", tint: Hill.stone) { openTrial = true }
                } else {
                    GateButton(title: "Walk to the post",
                               subtitle: "Outrun, lift, fetch, drive, shed and pen",
                               tint: Hill.bracken) { openTrial = true }
                }
            }
        }
    }

    private var flockCard: some View {
        CanvasCard {
            VStack(alignment: .leading, spacing: 10) {
                FieldHead(title: "The sheep you have drawn", note: meet.field.breed)
                Text(meet.field.blurb).font(Slate.body(14)).foregroundColor(Hill.inkSoft)
                    .fixedSize(horizontal: false, vertical: true)
                HStack(spacing: 10) {
                    CountChip(value: String(format: "%.0f", meet.field.flightZone * 100),
                              label: "flight zone", tint: Hill.rosetteRed)
                    CountChip(value: String(format: "%.0f", meet.field.sheepSpeed * 100),
                              label: "speed", tint: Hill.sepia)
                    CountChip(value: String(format: "%.0f", meet.field.stubborn * 100),
                              label: "stubborn", tint: Hill.bracken)
                }
                HStack(spacing: 5) {
                    ForEach(0..<5, id: \.self) { i in
                        Circle()
                            .fill(i < meet.field.difficulty ? Hill.bracken : Hill.canvasSunk)
                            .frame(width: 7, height: 7)
                    }
                    Text("ground").font(Slate.body(11)).foregroundColor(Hill.inkPale)
                }
            }
        }
    }

    private var drillCard: some View {
        CanvasCard {
            VStack(alignment: .leading, spacing: 10) {
                FieldHead(title: "The morning gather", note: "a minute on the hill")
                Text("Send him out, lift them quietly and fetch them to your feet. No drive, no shed, no pen. It is what the dog does every morning of its working life, and the run of days counts it.")
                    .font(Slate.body(14)).foregroundColor(Hill.inkSoft)
                    .fixedSize(horizontal: false, vertical: true)
                HStack(spacing: 10) {
                    CountChip(value: "\(drillField.sheepCount)", label: "sheep", onCanvas: true)
                    CountChip(value: "\(store.drills)", label: "gathers", onCanvas: true)
                    CountChip(value: store.drills > 0
                              ? "\(Int((store.drillBest * 100).rounded()))" : "—",
                              label: "best", onCanvas: true)
                }
                Text(drillField.name).font(Slate.title(16)).foregroundColor(Hill.ink)
                GateButton(title: "Take the gather", subtitle: drillField.place,
                           tint: Hill.moss) { openDrill = true }
            }
        }
    }

    private var boardCard: some View {
        let earned = HonourBoard.all.filter { store.earnedHonours.contains($0.id) }
        let next = HonourBoard.all.first { !store.earnedHonours.contains($0.id) }
        return CanvasCard {
            VStack(alignment: .leading, spacing: 10) {
                FieldHead(title: "The honours board",
                          note: "\(earned.count) of \(HonourBoard.all.count) won")
                HStack(spacing: 8) {
                    ForEach(HonourBoard.all.prefix(6)) { honour in
                        HonourEmblem(kind: honour.emblem,
                                     earned: store.earnedHonours.contains(honour.id), size: 42)
                    }
                    Spacer(minLength: 0)
                }
                PointRow(label: "Won", value: Double(earned.count) / Double(HonourBoard.all.count),
                         maxPoints: HonourBoard.all.count, tint: Hill.rosetteRed)
                if let next = next {
                    Text("Still open: \(next.title) — \(next.note)")
                        .font(Slate.body(13)).foregroundColor(Hill.inkSoft)
                        .fixedSize(horizontal: false, vertical: true)
                } else {
                    Text("There is nothing left on the board to win.")
                        .font(Slate.italic(13)).foregroundColor(Hill.rosetteRed)
                }
            }
        }
    }

    private var standingCard: some View {
        CanvasCard {
            VStack(alignment: .leading, spacing: 11) {
                FieldHead(title: "In the shepherds' book", note: store.rank.note)
                HStack(spacing: 10) {
                    CountChip(value: "\(store.liveStreak)", label: "day streak", tint: Hill.brass)
                    CountChip(value: "\(store.points)", label: "points", tint: Hill.bracken)
                    CountChip(value: "\(store.cardCount)/\(FieldBook.all.count)",
                              label: "fields", tint: Hill.moss)
                }
                if let next = store.nextRank {
                    VStack(alignment: .leading, spacing: 5) {
                        HStack {
                            Text("Toward \(next.name)").font(Slate.body(13))
                                .foregroundColor(Hill.inkSoft)
                            Spacer()
                            Text("\(store.points)/\(next.need)").font(Slate.figure(12))
                                .foregroundColor(Hill.inkPale)
                        }
                        GeometryReader { geo in
                            ZStack(alignment: .leading) {
                                Capsule().fill(Hill.canvasSunk)
                                Capsule().fill(Hill.brass)
                                    .frame(width: store.rankProgress * geo.size.width)
                            }
                        }
                        .frame(height: 8)
                    }
                } else {
                    Text("There is nothing above champion but next year's dog.")
                        .font(Slate.italic(13)).foregroundColor(Hill.inkPale)
                }
                HStack(spacing: 10) {
                    CountChip(value: "\(store.runs)", label: "runs")
                    CountChip(value: "\(store.pens)", label: "pens")
                    CountChip(value: "\(store.bestTotal)", label: "best card", tint: Hill.rosetteRed)
                }
            }
        }
    }

    private var readingCard: some View {
        let entry = CraftShelf.entries[day % CraftShelf.entries.count]
        return SlateCard {
            VStack(alignment: .leading, spacing: 9) {
                FieldHead(title: "Chalked on the shed door", note: entry.kicker, tint: Hill.brass)
                Text(entry.title).font(Slate.title(17)).foregroundColor(Hill.canvas)
                Text(entry.summary).font(Slate.body(14))
                    .foregroundColor(Hill.canvas.opacity(0.78))
                    .fixedSize(horizontal: false, vertical: true)
                Button(action: {
                    Nudge.light()
                    store.markPlate(entry.id)
                    plateTitle = entry.title
                    openPlate = entry.plate
                }) {
                    Text("Open the plate").font(Slate.title(13)).foregroundColor(Hill.brass)
                }
                .buttonStyle(.plain)
            }
        }
    }
}
