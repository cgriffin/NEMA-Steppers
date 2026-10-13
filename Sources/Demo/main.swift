import Cadova
import NEMA

await Project(packageRelative: "Models") {

	await Model("motor") {
		NEMA(size: .NEMA17, length: 40)
	}
}
