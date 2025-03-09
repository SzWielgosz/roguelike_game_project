extends NavigationRegion2D
@onready var barrels: Node = $Barrels
var bakings: int = 0
var is_baking: bool = false

func _ready():
	for barrel in barrels.get_children():
		if barrel.has_signal("destroyed"):
			barrel.destroyed.connect(_on_barrel_destroyed)

func _on_barrel_destroyed():
	bakings += 1
	if !is_baking:
		is_baking = true
		bake_navigation_polygon()

func _on_bake_finished():
	bakings -= 1
	if bakings > 0:
		bake_navigation_polygon()
	else:
		is_baking = false
