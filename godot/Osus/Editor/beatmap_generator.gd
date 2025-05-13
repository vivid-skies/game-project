extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	create_area()
	get_tree().quit()

func create_area() -> void:
	print('creating area')
	# Create root area node
	var area: Node3D = Node3D.new()
	area.name = "Area"
	
	# Create the floor
	var floor: StaticBody3D = StaticBody3D.new()
	area.add_child(floor)
	floor.owner = area
	floor.name = "Floor"
	
	var floor_mesh: MeshInstance3D = MeshInstance3D.new()
	floor.add_child(floor_mesh)
	floor_mesh.owner = area
	floor_mesh.name = "FloorMesh"
	
	var mesh: BoxMesh = BoxMesh.new()
	mesh.size = Vector3(30, 1, 30)
	floor_mesh.mesh = mesh
	
	var floor_collision: CollisionShape3D = CollisionShape3D.new()
	floor.add_child(floor_collision)
	floor_collision.owner = area
	floor_collision.name = "FloorCollision"
	
	var floor_collision_shape: BoxShape3D = BoxShape3D.new()
	floor_collision_shape.size = Vector3(30, 1, 30)
	floor_collision.shape = floor_collision_shape
	
	# Move the floor down
	floor.transform.origin -= floor.transform.basis.y * .5
	
	# Save Scene
	var scene: PackedScene = PackedScene.new()
	var result: int = scene.pack(area)
	if result == OK:
		var error: int = ResourceSaver.save(scene, "res://Osus/Editor/prefabs/area.tscn")
		if error != OK:
			push_error(("An error occurred while saving the scene to disk."))
