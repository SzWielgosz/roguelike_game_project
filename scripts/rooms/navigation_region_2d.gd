extends NavigationRegion2D
@onready var destroyables: Node = $Destroyables
var bakings: int = 0
var is_baking: bool = false

func _ready():
	for destroyable_type in destroyables.get_children():
		for destroyable in destroyable_type.get_children():
			destroyable.destroyed.connect(_on_destroyable_destroyed)
	self.bake_finished.connect(_on_bake_finished)

func _on_destroyable_destroyed():
	bakings += 1
	if !is_baking:
		is_baking = true
		loop_bake()

func _on_bake_finished():
	bakings -= 1

func loop_bake():
	while bakings > 0:
		bake_navigation_polygon()
		await bake_finished
	is_baking = false
