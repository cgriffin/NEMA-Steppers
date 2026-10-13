// The Swift Programming Language
// https://docs.swift.org/swift-book

import Cadova

public enum NEMASizes:Int, CaseIterable, Sendable {
	case NEMA8	= 0
	case NEMA14
	case NEMA16
	case NEMA17
	case NEMA23
}

public struct NEMA: Geometry3D {

	let size:			NEMASizes
	let length:			Double
	let connector:		Bool
	private let motor:	NEMASize

	private struct NEMASize {
		let side:			Double
		let cornderRad:	Double
		let bodyRad:		Double
		let bossRad:		Double
		let bossDepth:		Double
		let shaft:			Double
		let shaftLength:	Double
		let holes:			Double
		let capHeight:		Double
		let	thread:			Double
	}

	private struct NEMAStepperMotors {
		private var motors:	[NEMASize]	= [
			.init(side: 20.0,	cornderRad: 15.0,	bodyRad: 20.0,	bossRad: 7.5,	bossDepth: 1.6,	shaft: 4.0,		shaftLength: 6.0,	holes: 16.0,	capHeight: 8.0,	thread: 2.0),
			.init(side: 39.5,	cornderRad: 25.32,	bodyRad: 25.32,	bossRad: 11.0,	bossDepth: 2.0,	shaft: 5.0,		shaftLength: 12.0,	holes: 31.0,	capHeight: 8.0,	thread: 3.0),
			.init(side: 35.2,	cornderRad: 23.2,	bodyRad: 21.0,	bossRad: 11.0,	bossDepth: 2.0,	shaft: 5.0,		shaftLength: 21.0,	holes: 26.0,	capHeight: 8.0,	thread: 3.0),
			.init(side: 42.3,	cornderRad: 26.8,	bodyRad: 25.0,	bossRad: 11.0,	bossDepth: 2.0,	shaft: 5.0,		shaftLength: 24.0,	holes: 31.0,	capHeight: 8.0,	thread: 3.0),
			.init(side: 56.4,	cornderRad: 37.85,	bodyRad: 35.0,	bossRad: 19.05,	bossDepth: 1.6,	shaft: 6.35,	shaftLength: 24.0,	holes: 47.1,	capHeight: 8.0,	thread: 3.0)
		]

		subscript(_ motor: NEMASizes) -> NEMASize {
			return motors[motor.rawValue]
		}
	}

	public init(size: NEMASizes, length: Double, connector: Bool = false) {
		self.size	= size
		self.length	= length
		self.connector	= connector
		self.motor	= NEMAStepperMotors()[size]
	}

	public var body: any Geometry3D {
		Union {
			Intersection {								// Body
				Rectangle(motor.side)
					.aligned(at: .center)
				Circle(radius: motor.bodyRad)
			}
			.extruded(height: length - motor.capHeight*2)
			.aligned(at: .centerZ)
			.colored(.black)

			// End caps
			for end in [-1.0, 1.0] {
				capShape(end: end)
					.extruded(height: motor.capHeight)
					.aligned(at: .centerZ)
					.translated(z: (length-motor.capHeight)/2.0 * end)
			}

			Circle(radius: motor.bossRad)
				.subtracting {
					Circle(radius: motor.shaft/2 + 2)
				}
				.extruded(height: motor.bossDepth)
				.translated(z: length/2)

			Cylinder(diameter: motor.shaft, height: motor.shaftLength)
				.translated(z: length/2)
		}
		.translated(z: -length/2)
	}

	func capShape(end: Double) -> any Geometry2D {
		return Union {
			Intersection {
				Rectangle(motor.side - 0.01)
					.aligned(at: .center)
				Circle(radius: motor.cornderRad)
			}
			.subtracting {
				if end > 0 {
					for x in [-motor.holes/2, motor.holes/2] {
						for y in [-motor.holes/2, motor.holes/2] {
							Circle(diameter: motor.thread)
								.translated(x: x, y: y)
						}
					}
				}
			}
			if connector && end < 0 {

			}
		}
	}
}
