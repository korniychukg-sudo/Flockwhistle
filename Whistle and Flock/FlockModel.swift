import SwiftUI

enum DogCommand: String {
    case comeBye
    case awayToMe
    case walkUp
    case steady
    case lieDown
    case thatllDo

    var title: String {
        switch self {
        case .comeBye: return "Come bye"
        case .awayToMe: return "Away to me"
        case .walkUp: return "Walk up"
        case .steady: return "Steady"
        case .lieDown: return "Lie down"
        case .thatllDo: return "That'll do"
        }
    }

    var shape: String {
        switch self {
        case .comeBye: return "rise"
        case .awayToMe: return "fall"
        case .walkUp: return "riseflat"
        case .steady: return "flat"
        case .lieDown: return "fallflat"
        case .thatllDo: return "risefall"
        }
    }

    var note: String {
        switch self {
        case .comeBye: return "Flank clockwise round the sheep"
        case .awayToMe: return "Flank anticlockwise round the sheep"
        case .walkUp: return "Come straight on to them"
        case .steady: return "Slow down and ease off"
        case .lieDown: return "Stop where you are"
        case .thatllDo: return "Leave them and come back"
        }
    }
}

let allCommands: [DogCommand] = [.comeBye, .awayToMe, .walkUp, .steady, .lieDown, .thatllDo]

func whistleContour(_ shape: String, steps: Int = 24) -> [CGPoint] {
    var out: [CGPoint] = []
    for k in 0..<steps {
        let t = Double(k) / Double(steps - 1)
        var y = 0.5
        switch shape {
        case "rise": y = 0.85 - t * 0.7
        case "fall": y = 0.15 + t * 0.7
        case "riseflat": y = t < 0.5 ? 0.85 - t * 2 * 0.7 : 0.15
        case "flat": y = 0.5
        case "fallflat": y = t < 0.5 ? 0.15 + t * 2 * 0.7 : 0.85
        default: y = 0.85 - sin(t * Double.pi) * 0.7
        }
        out.append(CGPoint(x: t, y: y))
    }
    return out
}

func recogniseWhistle(_ points: [CGPoint]) -> DogCommand? {
    guard points.count > 6 else { return nil }
    var minX = Double.greatestFiniteMagnitude, maxX = -Double.greatestFiniteMagnitude
    var minY = Double.greatestFiniteMagnitude, maxY = -Double.greatestFiniteMagnitude
    for p in points {
        minX = min(minX, Double(p.x)); maxX = max(maxX, Double(p.x))
        minY = min(minY, Double(p.y)); maxY = max(maxY, Double(p.y))
    }
    guard maxX - minX > 0.18 else { return nil }
    let spanY = max(0.0001, maxY - minY)
    var norm: [CGPoint] = []
    for p in points {
        norm.append(CGPoint(x: (Double(p.x) - minX) / max(0.0001, maxX - minX),
                            y: (Double(p.y) - minY) / spanY))
    }

    func sample(_ t: Double) -> Double {
        var best = 0.0
        var bestD = Double.greatestFiniteMagnitude
        for p in norm {
            let d = abs(Double(p.x) - t)
            if d < bestD { bestD = d; best = Double(p.y) }
        }
        return best
    }

    let flat = spanY < 0.10
    if flat { return .steady }

    let a = sample(0.05), mid = sample(0.5), b = sample(0.95)
    let quarter = sample(0.28), threeQuarter = sample(0.72)

    let rising = a - b
    if mid < a - 0.25 && mid < b - 0.25 { return .thatllDo }
    if abs(threeQuarter - b) < 0.16 && quarter - threeQuarter > 0.3 { return .walkUp }
    if abs(threeQuarter - b) < 0.16 && threeQuarter - quarter > 0.3 { return .lieDown }
    if rising > 0.32 { return .comeBye }
    if rising < -0.32 { return .awayToMe }
    return nil
}

struct Ewe {
    var p: CGPoint
    var v: CGPoint
    var shed: Bool = false
}

struct FlockField {
    var flightZone: Double
    var speed: Double
    var stubborn: Double
}

final class FlockSim: ObservableObject {
    @Published var sheep: [Ewe] = []
    @Published var dog: CGPoint = CGPoint(x: 0.5, y: 0.94)
    @Published var command: DogCommand = .lieDown
    @Published var track: [CGPoint] = []

    var handler = CGPoint(x: 0.5, y: 0.95)
    var config = FlockField(flightZone: 0.16, speed: 0.10, stubborn: 0.5)
    private var dogAngle: Double = -Double.pi / 2
    private var rng = Roll(9901)

    func reset(count: Int, config: FlockField, seed: UInt64) {
        self.config = config
        rng = Roll(seed)
        sheep = []
        for k in 0..<count {
            let a = Double(k) / Double(count) * 2 * Double.pi
            sheep.append(Ewe(p: CGPoint(x: 0.5 + cos(a) * rng.range(0.01, 0.045),
                                        y: 0.12 + sin(a) * rng.range(0.01, 0.035)),
                             v: .zero))
        }
        dog = CGPoint(x: 0.5, y: 0.90)
        command = .lieDown
        track = []
    }

    var centre: CGPoint {
        guard !sheep.isEmpty else { return CGPoint(x: 0.5, y: 0.5) }
        var x = 0.0, y = 0.0
        for s in sheep { x += Double(s.p.x); y += Double(s.p.y) }
        return CGPoint(x: x / Double(sheep.count), y: y / Double(sheep.count))
    }

    var spread: Double {
        let c = centre
        var worst = 0.0
        for s in sheep {
            let dx = Double(s.p.x - c.x), dy = Double(s.p.y - c.y)
            worst = max(worst, (dx * dx + dy * dy).squareRoot())
        }
        return worst
    }

    func step(dt: Double) {
        moveDog(dt: dt)
        moveSheep(dt: dt)
        let c = centre
        if let last = track.last {
            let dx = Double(c.x - last.x), dy = Double(c.y - last.y)
            if (dx * dx + dy * dy).squareRoot() > 0.006 { track.append(c) }
        } else {
            track.append(c)
        }
    }

    private func moveDog(dt: Double) {
        let c = centre
        var speed = 0.34
        var target = dog

        switch command {
        case .lieDown:
            return
        case .steady:
            speed = 0.13
            let toC = atan2(Double(dog.y - c.y), Double(dog.x - c.x))
            let radius = 0.20
            target = CGPoint(x: Double(c.x) + cos(toC) * radius,
                             y: Double(c.y) + sin(toC) * radius)
        case .walkUp:
            let toC = atan2(Double(dog.y - c.y), Double(dog.x - c.x))
            target = CGPoint(x: Double(c.x) + cos(toC) * 0.09,
                             y: Double(c.y) + sin(toC) * 0.09)
            speed = 0.22
        case .thatllDo:
            target = handler
            speed = 0.40
        case .comeBye, .awayToMe:
            let dir: Double = command == .comeBye ? 1 : -1
            dogAngle = atan2(Double(dog.y - c.y), Double(dog.x - c.x))
            dogAngle += dir * dt * 1.9
            let radius = max(0.16, min(0.34, hypot(Double(dog.x - c.x), Double(dog.y - c.y))))
            target = CGPoint(x: Double(c.x) + cos(dogAngle) * radius,
                             y: Double(c.y) + sin(dogAngle) * radius)
            speed = 0.42
        }

        var dx = Double(target.x - dog.x), dy = Double(target.y - dog.y)
        let d = (dx * dx + dy * dy).squareRoot()
        if d > 0.0001 {
            dx /= d; dy /= d
            let move = min(d, speed * dt)
            dog = CGPoint(x: Double(dog.x) + dx * move, y: Double(dog.y) + dy * move)
        }
        dog = CGPoint(x: max(0.02, min(0.98, Double(dog.x))),
                      y: max(0.02, min(0.98, Double(dog.y))))
    }

    private func moveSheep(dt: Double) {
        let zone = config.flightZone * (command == .lieDown ? 0.55 : 1.0)
        var next = sheep
        for i in sheep.indices {
            var ax = 0.0, ay = 0.0
            let me = sheep[i]

            for j in sheep.indices where j != i {
                let other = sheep[j]
                let dx = Double(me.p.x - other.p.x), dy = Double(me.p.y - other.p.y)
                let d = max(0.0001, (dx * dx + dy * dy).squareRoot())
                if d < 0.035 {
                    ax += dx / d * (0.035 - d) * 9
                    ay += dy / d * (0.035 - d) * 9
                } else if d < 0.16 {
                    ax -= dx / d * 0.05
                    ay -= dy / d * 0.05
                    ax += Double(other.v.x) * 0.08
                    ay += Double(other.v.y) * 0.08
                }
            }

            let dxd = Double(me.p.x - dog.x), dyd = Double(me.p.y - dog.y)
            let dd = max(0.0001, (dxd * dxd + dyd * dyd).squareRoot())
            if dd < zone {
                let push = (1 - dd / zone) * (1.4 - config.stubborn * 0.5)
                ax += dxd / dd * push
                ay += dyd / dd * push
            }

            if me.p.x < 0.06 { ax += (0.06 - Double(me.p.x)) * 6 }
            if me.p.x > 0.94 { ax -= (Double(me.p.x) - 0.94) * 6 }
            if me.p.y < 0.05 { ay += (0.05 - Double(me.p.y)) * 6 }
            if me.p.y > 0.95 { ay -= (Double(me.p.y) - 0.95) * 6 }

            var vx = Double(me.v.x) + ax * dt
            var vy = Double(me.v.y) + ay * dt
            vx *= 0.90
            vy *= 0.90
            let sp = (vx * vx + vy * vy).squareRoot()
            let cap = config.speed * (dd < zone * 0.6 ? 1.7 : 1.0)
            if sp > cap {
                vx = vx / sp * cap
                vy = vy / sp * cap
            }
            next[i].v = CGPoint(x: vx, y: vy)
            next[i].p = CGPoint(x: max(0.02, min(0.98, Double(me.p.x) + vx * dt)),
                                y: max(0.02, min(0.98, Double(me.p.y) + vy * dt)))
        }
        sheep = next
    }
}

struct CoursePoint {
    let at: CGPoint
    let label: String
}

struct TrialCourse {
    let post = CGPoint(x: 0.5, y: 0.93)
    let top = CGPoint(x: 0.5, y: 0.10)
    let fetchGate = CGPoint(x: 0.5, y: 0.42)
    let driveGate = CGPoint(x: 0.84, y: 0.40)
    let crossGate = CGPoint(x: 0.16, y: 0.40)
    let shedRing = CGPoint(x: 0.5, y: 0.74)
    let pen = CGPoint(x: 0.22, y: 0.82)
    let gateWidth = 0.11
    let ringRadius = 0.15

    func idealLine(for phase: TrialPhase) -> (CGPoint, CGPoint) {
        switch phase {
        case .outrun, .lift: return (top, top)
        case .fetch: return (top, post)
        case .drive: return (post, driveGate)
        case .crossDrive: return (driveGate, crossGate)
        case .shed: return (crossGate, shedRing)
        case .pen: return (shedRing, pen)
        default: return (post, post)
        }
    }
}

enum TrialPhase: Int {
    case waiting
    case outrun
    case lift
    case fetch
    case drive
    case crossDrive
    case shed
    case pen
    case finished

    var title: String {
        switch self {
        case .waiting: return "At the post"
        case .outrun: return "The outrun"
        case .lift: return "The lift"
        case .fetch: return "The fetch"
        case .drive: return "The drive"
        case .crossDrive: return "The cross-drive"
        case .shed: return "The shed"
        case .pen: return "The pen"
        case .finished: return "Run over"
        }
    }

    var points: Int {
        switch self {
        case .outrun: return 20
        case .lift: return 10
        case .fetch: return 20
        case .drive: return 15
        case .crossDrive: return 15
        case .shed: return 10
        case .pen: return 10
        default: return 0
        }
    }
}

struct TrialResult {
    var outrun: Double
    var lift: Double
    var fetch: Double
    var drive: Double
    var crossDrive: Double
    var shed: Double
    var pen: Double
    var seconds: Double
    var commands: Int

    var total: Int {
        Int((outrun * 20 + lift * 10 + fetch * 20 + drive * 15 + crossDrive * 15
             + shed * 10 + pen * 10).rounded())
    }

    var overall: Double { Double(total) / 100.0 }

    var grade: String {
        switch total {
        case 90...: return "A"
        case 78..<90: return "B"
        case 62..<78: return "C"
        case 44..<62: return "D"
        default: return "E"
        }
    }

    var points: Int { total + commands }
}

func rosetteTint(_ grade: String) -> Color {
    switch grade {
    case "A": return Hill.rosetteRed
    case "B": return Hill.rosetteBlue
    case "C": return Hill.brass
    case "D": return Hill.bracken
    default: return Hill.stone
    }
}

func distance(_ a: CGPoint, _ b: CGPoint) -> Double {
    let dx = Double(a.x - b.x), dy = Double(a.y - b.y)
    return (dx * dx + dy * dy).squareRoot()
}

func distanceToLine(_ p: CGPoint, _ a: CGPoint, _ b: CGPoint) -> Double {
    let vx = Double(b.x - a.x), vy = Double(b.y - a.y)
    let wx = Double(p.x - a.x), wy = Double(p.y - a.y)
    let len2 = vx * vx + vy * vy
    guard len2 > 0.000001 else { return distance(p, a) }
    var t = (wx * vx + wy * vy) / len2
    t = max(0, min(1, t))
    let cx = Double(a.x) + vx * t, cy = Double(a.y) + vy * t
    let dx = Double(p.x) - cx, dy = Double(p.y) - cy
    return (dx * dx + dy * dy).squareRoot()
}
