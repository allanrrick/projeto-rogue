extends GPUParticles2D

@export var tamanho_pixel: float = 1.0
@export_range(1, 20) var divisor_quantidade: int = 1

@export_group("Comportamento da Explosão")
## Tempo em segundos para os pixels sumirem completamente
@export var duracao: float = 1
## Velocidade com que os pixels se espalham (menor = mais perto do inimigo)
@export var velocidade_espalhamento: float = 35.0
## Desaceleração no ar (maior = freia mais rápido após explodir)
@export var freio_ar: float = 40.0

func emit(anim_sprite: AnimatedSprite2D) -> void:
	var atlas_tex: Texture2D = anim_sprite.sprite_frames.get_frame_texture(
		anim_sprite.animation, 
		anim_sprite.frame
	)
	if not atlas_tex:
		queue_free()
		return

	var frame_img: Image = atlas_tex.get_image()
	var frame_tex: ImageTexture = ImageTexture.create_from_image(frame_img)

	if not texture:
		var pixel_img := Image.create(1, 1, false, Image.FORMAT_RGBA8)
		pixel_img.fill(Color.WHITE)
		texture = ImageTexture.create_from_image(pixel_img)

	# Define duração e quantidade
	lifetime = duracao
	var total_pixels := frame_tex.get_width() * frame_tex.get_height()
	amount = max(1, int(total_pixels / divisor_quantidade))

	# Configura o material
	var mat := process_material.duplicate() as ShaderMaterial
	process_material = mat
	
	mat.set_shader_parameter("sprite", frame_tex)
	mat.set_shader_parameter("sprite_frame", 0)
	mat.set_shader_parameter("sprite_hframes", 1)
	mat.set_shader_parameter("sprite_vframes", 1)

	# Tamanho dos pixels
	mat.set_shader_parameter("scale_min", tamanho_pixel)
	mat.set_shader_parameter("scale_max", tamanho_pixel)

	# Espalhamento e freio
	mat.set_shader_parameter("initial_linear_velocity_min", velocidade_espalhamento * 0.7)
	mat.set_shader_parameter("initial_linear_velocity_max", velocidade_espalhamento)
	mat.set_shader_parameter("damping_min", freio_ar)
	mat.set_shader_parameter("damping_max", freio_ar)

	# Posição e escala
	global_position = anim_sprite.global_position
	scale = anim_sprite.global_scale
	if anim_sprite.flip_h:
		scale.x *= -1
	if anim_sprite.flip_v:
		scale.y *= -1

	emitting = true
	await finished
	queue_free()
