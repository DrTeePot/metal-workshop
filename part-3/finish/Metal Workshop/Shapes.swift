import Foundation
import MetalKit

struct Vertex {
	let position: vector_float4
	let color: vector_float4
}

struct PulsingCircleUniform {
	let windowSize: float2
	let windowOrigin: float2
	let animationTime: float_t
}

protocol Shape {
	var vertices: [CGPoint] { get }
	var indices: [UInt16] { get }

	func mtlVertices() -> [Vertex]
}

extension Shape {
	func mtlVertices() -> [Vertex] {
		return self.vertices.map {
			return Vertex(
				position: [Float($0.x), Float($0.y), 0, 1],
				color: [0, 1, 0, 1])
		}
	}
}

struct PulsingCircle: Shape {

	var windowOrigin: CGPoint
	var animationTime: TimeInterval

	public let vertices: [CGPoint] = [
		CGPoint(x: -0.5, y: 0.5),
		CGPoint(x: -0.5, y: -0.5),
		CGPoint(x: 0.5,  y: -0.5),
		CGPoint(x: 0.5,  y: 0.5),
		]

	public let indices: [UInt16] =  [0, 1, 3, 2]

	init(windowOrigin: CGPoint,
	     animationTime: TimeInterval = 0) {
			self.windowOrigin = windowOrigin
			self.animationTime = animationTime
	}

	func unform(windowSize: CGSize) -> PulsingCircleUniform {
		return PulsingCircleUniform(
			windowSize: windowSize.toFloat2(),
			windowOrigin: self.windowOrigin.toFloat2(),
			animationTime: Float(self.animationTime))
	}

	mutating func add(timestep: TimeInterval) {
		var newTime = self.animationTime + timestep
		if newTime > 2 * Double.pi {
			newTime = 0
		}
		self.animationTime = newTime
	}
}
