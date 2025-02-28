extends NavigationRegion2D
@onready var barrels: Node = $Barrels

func _ready():
	for barrel in barrels.get_children():
		if barrel.has_signal("destroyed"):
			barrel.destroyed.connect(_on_barrel_destroyed)

func _on_barrel_destroyed():
	bake_navigation_polygon()
