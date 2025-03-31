extends NavigationRegion2D
@onready var destroyables: Node = $Destroyables
var bakings: int = 0
var is_baking: bool = false

func _ready():
	for destroyable_type in destroyables.get_children():
		for destroyable in destroyable_type.get_children():
			destroyable.destroyed.connect(_on_barrel_destroyed)

func _on_barrel_destroyed():
	bakings += 1
	if !is_baking:
		is_baking = true
		await get_tree().process_frame
		bake_navigation_polygon()

func _on_bake_finished():
	bakings -= 1
	if bakings > 0:
		bake_navigation_polygon()
	else:
		is_baking = false
