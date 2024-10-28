extends Node

#styling guide: https://godotvr.github.io/godot_openxr_vendors/manual/meta/passthrough.html
var fb_passthrough: Object = Engine.get_singleton("OpenXRFbPassthroughExtensionWrapper")
enum STYLE_TYPE { COLOR_MAP , MONO_MAP , BCS , COLOR_LUT, INTERPOLATED_COLOR_LUT, DISABLED}

@export var update_passthrough:= false

@export var style :STYLE_TYPE  = 5 : 
	set(value):
		if style != value:
			print("style changed: ", style)
		style = value
		
		match style:
			0:
				fb_passthrough.set_color_map(color_map)
			1:
				fb_passthrough.set_mono_map(mono_map)
			2:
				fb_passthrough.set_brightness_contrast_saturation(brightness, contrast, saturation)
			3: 
				if source_lut and channels:
					var source : OpenXRMetaPassthroughColorLut = fb_passthrough.create_from_image(source_lut, channels)
					fb_passthrough.set_color_lut(lut_weight, source)
				
			4: 
				if source_lut and channels and target_lut:
					var source : OpenXRMetaPassthroughColorLut = fb_passthrough.create_from_image(source_lut, channels)
					var target : OpenXRMetaPassthroughColorLut = fb_passthrough.create_from_image(target_lut, channels)
					fb_passthrough.set_interpolated_color_lut(lut_weight, source, target)
				
			5:
				fb_passthrough.set_passthrough_filter(0) #0 is disabled
				
@export_category("Color Map")
@export var color_map : Gradient : 
	set(value):
		color_map = value
		#set_style(STYLE_TYPE.COLOR_MAP)
		style = style
		fb_passthrough.set_color_map(color_map)

@export_category("Mono Map")
@export var mono_map : Curve : 
	set(value):
		mono_map = value
		#set_style(style)
		style = style
		fb_passthrough.set_mono_map(mono_map)


@export_category("BCS")
@export_range (-100, 100, 0.01) var brightness : float = 0 :#neutral is 0
	set(value):
		brightness = value
		#set_style(style)
		style = style
@export_range (0, 10, 0.01) var contrast : float = 1 : #neutral is 1
	set(value):
		contrast = value
		#set_style(style)
		style = style
@export_range (0, 10, 0.01) var saturation : float = 1 :#neutral is 1
	set(value):
		saturation = value
		#set_style(style)
		style = style

@export_category("Color LUT")
enum LUT_CHANNELS {RGB, RGBA}
@export var channels : LUT_CHANNELS :
	set(value):
		channels = value
		update_lut()
		
@export_range (0, 1, 0.01) var lut_weight : float = 0 :
	set(value):
		lut_weight = value
		update_lut()

@export var source_lut : Image :
	set(value):
		source_lut = value
		update_lut()
@export var target_lut : Image :
	set(value):
		target_lut = value
		update_lut()

@export_category("Always On") 
@export var edge_color : Color :
	set(value):
		edge_color = value
		#set alpha to zero to turn off
		fb_passthrough.set_edge_color(edge_color)
		
@export_range (0, 1, 0.001) var texture_opacity : float = 1.0: 
	set(value):
		texture_opacity = value
		fb_passthrough.set_texture_opacity_factor(texture_opacity)


func _ready() -> void:
	style = style
	fb_passthrough.set_mono_map(mono_map)
	#update_lut()
	#style = style
	#edge_color=edge_color
	#texture_opacity = texture_opacity
	pass
	
func _process(delta: float) -> void:
	if update_passthrough:
		style = style

	
func update_lut()->void:
	style = style
	pass
