extends NavigationRegion2D


func _on_barrel_destroyed():
	bake_navigation_polygon()
