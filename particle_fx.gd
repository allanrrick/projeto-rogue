extends Node2D

var effects = {
	"fire_dash" : load("res://Particles/fire_dash_particles.tres")
};
var particle = preload("res://Utility/particles.tscn");

func add_effect(effect_name : String, pos: Vector2, parent: Node = null):
	if effect_name not in effects:
		return	
	
	var effect = effects[effect_name];
	if parent == null:
		parent = get_tree().current_scene;
		
	var particle_instance = particle.instantiate();
	particle_instance.process_material = effect;
	particle_instance.global_position = pos;
	parent.add_child(particle_instance);
