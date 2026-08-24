import SwiftUI

struct TrialRootView: View {
    @EnvironmentObject var store: TrialStore
    @State private var tab = 0
    @State private var lastTab = 0

    var body: some View {
        ZStack {
            if store.onboarded { shell }
            else { TrialOnboarding { store.markOnboarded() }.transition(.opacity) }
        }
        .animation(.easeInOut(duration: 0.35), value: store.onboarded)
    }

    private var shell: some View {
        VStack(spacing: 0) {
            Group {
                switch tab {
                case 0:
                    NavigationView { MorningView() }.navigationViewStyle(StackNavigationViewStyle())
                case 1:
                    NavigationView { MeetView() }.navigationViewStyle(StackNavigationViewStyle())
                case 2:
                    NavigationView { FieldsView() }.navigationViewStyle(StackNavigationViewStyle())
                case 3:
                    NavigationView { CraftView() }.navigationViewStyle(StackNavigationViewStyle())
                default:
                    NavigationView { CardsView() }.navigationViewStyle(StackNavigationViewStyle())
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .id(tab)
            .transition(.asymmetric(
                insertion: .move(edge: tab > lastTab ? .trailing : .leading).combined(with: .opacity),
                removal: .opacity))
            tabBar
        }
        .hillPage()
    }

    private var tabBar: some View {
        VStack(spacing: 0) {
            Rectangle()
                .fill(LinearGradient(colors: [Color.black.opacity(0.30), Color.clear],
                                     startPoint: .bottom, endPoint: .top))
                .frame(height: 8)
            HStack(spacing: 0) {
                tabButton(0, "Yard", AnyView(DogGlyph(size: 22, color: tint(0))))
                tabButton(1, "Run", AnyView(WhistleGlyph(size: 21, color: tint(1))))
                tabButton(2, "Hills", AnyView(SheepGlyph(size: 22, color: tint(2))))
                tabButton(3, "Shed", AnyView(CrookGlyph(size: 21, color: tint(3))))
                tabButton(4, "Cards", AnyView(RosetteGlyph(size: 21, color: tint(4))))
            }
            .padding(.top, 9).padding(.bottom, 3)
            .background(Hill.turfDeep.edgesIgnoringSafeArea(.bottom))
        }
    }

    private func tint(_ i: Int) -> Color { tab == i ? Hill.brass : Hill.canvas.opacity(0.55) }

    private func tabButton(_ index: Int, _ label: String, _ icon: AnyView) -> some View {
        Button(action: {
            guard tab != index else { return }
            Nudge.light()
            lastTab = tab
            withAnimation(.easeInOut(duration: 0.28)) { tab = index }
        }) {
            VStack(spacing: 3) {
                icon
                Text(label).font(Slate.body(10)).foregroundColor(tint(index))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 5)
            .background(
                RoundedRectangle(cornerRadius: 9, style: .continuous)
                    .fill(Color.white.opacity(tab == index ? 0.08 : 0))
                    .padding(.horizontal, 5)
            )
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

struct TrialOnboarding: View {
    let onDone: () -> Void
    @State private var page = 0

    private let pages: [(String, String, Int)] = [
        ("You do not steer the dog",
         "You tell it which way to go round the sheep, and the sheep answer the dog. Everything on the course happens at one remove from you.",
         0),
        ("Six whistles, drawn not tapped",
         "Come bye rises, away to me falls, walk up rises and holds, steady is flat, lie down falls and holds, that'll do goes up and comes back. Draw the shape on the pad.",
         1),
        ("The pear-shaped outrun",
         "Send the dog wide. It must come in behind the sheep without ever showing itself from the front, and a dog that changes sides has crossed its course.",
         2),
        ("Then the line, and the pen",
         "Fetch through the gates, drive away and across, shed in the ring and pen them. A hundred points, and the judge takes them off one at a time.",
         3),
    ]

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                if page > 0 {
                    Button(action: { Nudge.light(); withAnimation { page -= 1 } }) {
                        MarkGlyph(size: 16, color: Hill.canvas, facing: .pi)
                            .padding(9).background(Circle().fill(Hill.slate))
                    }
                    .buttonStyle(.plain)
                }
                Spacer()
                Button(action: { Nudge.light(); onDone() }) {
                    Text("Skip").font(Slate.title(14)).foregroundColor(Hill.canvas.opacity(0.7))
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, Pitch.gutter).padding(.top, 14)

            Spacer(minLength: 0)
            VStack(spacing: 22) {
                ZStack {
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .fill(Hill.slate)
                        .frame(width: 176, height: 176)
                    switch pages[page].2 {
                    case 0: DogGlyph(size: 104, color: Hill.canvas)
                    case 1: WhistleGlyph(size: 96, color: Hill.brass)
                    case 2: SheepGlyph(size: 104, color: Hill.fleece)
                    default: RosetteGlyph(size: 96, color: Hill.rosetteRed)
                    }
                }
                VStack(spacing: 12) {
                    Text(pages[page].0).font(Slate.title(24)).foregroundColor(Hill.canvas)
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                    Text(pages[page].1).font(Slate.body(16))
                        .foregroundColor(Hill.canvas.opacity(0.78))
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(.horizontal, 26)
            }
            .id(page)
            .transition(.opacity)
            Spacer(minLength: 0)

            HStack(spacing: 7) {
                ForEach(0..<pages.count, id: \.self) { i in
                    Circle().fill(i == page ? Hill.brass : Hill.canvas.opacity(0.35))
                        .frame(width: 7, height: 7)
                }
            }
            .padding(.bottom, 18)
            GateButton(title: page == pages.count - 1 ? "Out to the field" : "Next",
                       tint: Hill.bracken) {
                if page == pages.count - 1 { onDone() }
                else { withAnimation(.easeInOut(duration: 0.28)) { page += 1 } }
            }
            .padding(.horizontal, Pitch.gutter).padding(.bottom, 26)
        }
        .hillPage()
        .centreColumn()
    }
}
