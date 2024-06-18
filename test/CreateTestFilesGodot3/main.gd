extends Node

export var dir_writable: String = "res://test_data"

const FILENAME_GODOT3: String = "/godot3.dat"
const FILENAME_GODOT3_ENCRYPTED: String = "/godot3_encrypted.dat"
const FILENAME_GODOT3_CONFIG_FILE: String = "/godot3_config_file.txt"
const FILENAME_GODOT3_CONFIG_FILE_ENCRYPTED: String = "/godot3_config_file_encrypted.dat"

var path_godot3: String
var path_godot3_encrypted: String
var path_godot3_config_file: String
var path_godot3_config_file_encrypted: String

const PASSWORD: String = "godot"

# Test data - basic types
const B: bool = true
const I: int = 42
const F: float = 7.5
const S: String = "hello"
const V: Vector2 = Vector2(1.1, 2.2)
const R2: Rect2 = Rect2(-1.1, -2.2, 3.3, 4.4)
const V3: Vector3 = Vector3(5.5, 6.6, 7.7)
const T2D: Transform2D = Transform2D(PI, Vector2(9.9, 10.10))
const P: Plane = Plane(0.1, 0.2, 0.3, 0.4)
const Q: Quat = Quat(1.01, 2.02, 3.03, 4.04)
const AABB_: AABB = AABB(Vector3(1.0, 2.0, 3.0), Vector3(4.0, 5.0, 6.0))
const BASIS_: Basis = Basis(Vector3.LEFT, Vector3.RIGHT, Vector3.UP)
const T3D: Transform = Transform(BASIS_, Vector3.DOWN)
const C: Color = Color.purple
const NP: NodePath = NodePath("Node2D/Sprite17")
const RID_: RID = RID() #TODO: Give this a value?
var O: Object #TODO: Give this a value?
const D: Dictionary = {"a": 15, "b": 30}
const A: Array = [3, 4]
const PBA: PoolByteArray = PoolByteArray([17, 99])
const PIA: PoolIntArray = PoolIntArray([9, 8, 7])
const PFA: PoolRealArray = PoolRealArray([2.5, 4.5, 6.5])
const PSA: PoolStringArray = PoolStringArray(["a", "b", "c"])
const PV2A: PoolVector2Array = PoolVector2Array([Vector2.LEFT, Vector2.RIGHT])
const PV3A: PoolVector3Array = PoolVector3Array([Vector3.UP, Vector3.DOWN])
const PCA: PoolColorArray = PoolColorArray([Color.red, Color.blue, Color.green])

# Test data - nested Arrays and Dictionaries
const A2: Array = [[5, 6], [7, 8, 9]]
const A3: Array = [[5, 6], [7, 8], [[9, 10], [11]]]
const A4: Array = [[[0]]]
const A5: Array = [[5, 6, [7, 8]], [[[9, 10], 11]], 12]
const A6: Array = [{"a": "b"}, {"c": "d"}, {"e": ["f", "g"]}]
const A7: Array = [[PBA], [{1: PIA, 2: PFA}, PSA, [PV2A, PV3A]], PCA]
const D2: Dictionary = {"a": {"b": "c"}}
const D3: Dictionary = {"a": [55, 66]}
const D4: Dictionary = {"abc": {101: 202}}
const D5: Dictionary = {1: [77, {303: 404}], 88: {91: [92, 93]}}
const D6: Dictionary = {\
	"version": ["1.2.3.4.5", "alpha"],\
	"mushrooms": [1, 1, 1],\
	"pizza": [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],\
	"box_of_kittens": {\
		"ab": true, "cd": false, "ef": true, "gh": false, "ij": false,\
		"kl": true, "mn": false, "op": false\
	},\
	"blue_sky": 0,\
	"giant_tomatoes": 0,\
	"foo": 0,\
	"bar": [1, 2, 3, 4, 5, 1, 2, 3, 4, 5, 1, 2, 3, 4, 5, 1, 2, 3, 4, 5,\
		1, 2, 3, 4, 5, 1, 2, 3, 4, 5, 1, 2, 3, 4, 5, 1, 2, 3, 4, 5, \
		1, 2, 3, 4, 5, 1, 2, 3, 4, 5, 1, 2, 3, 4, 5, 1, 2, 3, 4, 5, ],\
	"monday": [0, 0, false, 8, 1, true, 1, 1, "down"],\
	"tuesday": "level1",\
	"wednesday": "levels",\
	"thursday": ["", false],\
	"friday": [-1, 1],\
	"saturday": Vector2(1.05, -2.061),\
	"sunday": "empty",\
	"january": "c1",\
	"february": "empty",\
	"march": "tomorrow",\
	"april": [3],\
	"may": [34],\
	"june": [9, 8, 7],\
	"july": "user",\
	"august": 0,\
	"september": ["yesterday", "next_week"]\
}
const D7: Dictionary = {\
	[1, 2, 3]: "hello",\
	{[1, 2]: {3: 4}}: ["goodbye"],\
}
const D8: Dictionary = {1: PBA, 2: [PIA, PFA], 3: {4: PSA}, 5: PV2A}

# Test data - 32-bit/64-bit numbers
const D9: Dictionary = {
	"int_64": 123456789012345,
	"float_64": 123456789012345.0,
	"vector2_64": Vector2(123456789012345.0, 123456789012345.0),
	"int_32": 123,
	"float_32": 123.0,
	"vector2_32": Vector2(123.0, 123.0),
}

# Test data - ConfigFile
const DATA: Dictionary = {
	"I": I,
	"F": F,
	"B": B,
	"S": S,
	"V": V,
	"A": A,
	"D": D,
}

onready var button: Button = $Panel/MakeTestFiles
onready var passed: Panel = $Panel/Passed
onready var failed: Panel = $Panel/Failed
onready var debug: Label = $Panel/Debug


func _ready() -> void:

	if Engine.get_version_info()["major"] != 3:
		button.hide()
		debug.text = "This project requires Godot 3."

	# Hide test result.
	passed.modulate.a = 0.0
	failed.modulate.a = 0.0

	button.focus_mode = Control.FOCUS_NONE
	# warning-ignore:return_value_discarded
	button.connect("pressed", self, "_on_button_pressed")

	#test
#	dump_object()


func _on_button_pressed() -> void:

	var ok: bool = true
	var tween: Tween = Tween.new()

	button.disabled = true

	add_child(tween)

	# Hide test result.
	# warning-ignore:return_value_discarded
	tween.interpolate_property(passed, "modulate:a", passed.modulate.a, 0.0, 1.0, Tween.TRANS_EXPO)
	# warning-ignore:return_value_discarded
	tween.interpolate_property(failed, "modulate:a", failed.modulate.a, 0.0, 1.0, Tween.TRANS_EXPO)
	# warning-ignore:return_value_discarded
	tween.start()
	yield(tween, "tween_completed")

	if not write_files():
		ok = false

	# Show test result.
	var panel: Panel = passed if ok else failed
	# warning-ignore:return_value_discarded
	tween.interpolate_property(panel, "modulate:a", panel.modulate.a, 1.0, 1.0, Tween.TRANS_EXPO)
	yield(tween, "tween_completed")

	button.disabled = false


func write_files() -> bool:

	var ok: bool = true

	path_godot3 = dir_writable + FILENAME_GODOT3
	path_godot3_encrypted = dir_writable + FILENAME_GODOT3_ENCRYPTED
	path_godot3_config_file = dir_writable + FILENAME_GODOT3_CONFIG_FILE
	path_godot3_config_file_encrypted = dir_writable + FILENAME_GODOT3_CONFIG_FILE_ENCRYPTED

	var directory: Directory = Directory.new()
	if not directory.dir_exists(dir_writable):
		#warning-ignore:return_value_discarded
		var err: int = directory.make_dir(dir_writable)
		if err != OK:
			print_debug("Failed to create directory '%s', err=%d" % [dir_writable, err])
			return false

	ok = ok and write_file(path_godot3)
	ok = ok and write_file(path_godot3_encrypted, true)
	ok = ok and write_config_file(path_godot3_config_file)
	ok = ok and write_config_file(path_godot3_config_file_encrypted, true)

	return ok


func write_file(path: String, encrypted: bool = false) -> bool:

	var file: File = File.new()
	var err: int

	var ok: bool = true

	if encrypted:
		err = file.open_encrypted_with_pass(path, File.WRITE, PASSWORD)
	else:
		err = file.open(path, File.WRITE)
	if err == OK:
		print_debug("Successfully opened file '%s' for writing " % path)
	else:
		print_debug("Failed to open file '%s' for writing, error=%d" % [path, err])
		return false

	# Basic types
	file.store_var(B)
	file.store_var(I)
	file.store_8(I)
	file.store_16(I)
	file.store_32(I)
	file.store_64(I)
	file.store_var(F)
	file.store_double(F)
	file.store_float(F)
	file.store_real(F)
	file.store_var(S)
	file.store_pascal_string(S)
	file.store_var(V)
	file.store_var(R2)
	file.store_var(V3)
	file.store_var(T2D)
	file.store_var(P)
	file.store_var(Q)
	file.store_var(AABB_)
	file.store_var(BASIS_)
	file.store_var(T3D)
	file.store_var(C)
	file.store_var(NP)
#	file.store_var(RID_)
#	file.store_var(O, true)
	file.store_var(D)
	file.store_var(A)
	file.store_var(PBA)
	file.store_buffer(PBA)
	file.store_var(PIA)
	file.store_var(PFA)
	file.store_var(PSA)
	file.store_csv_line(PSA)
	file.store_var(PV2A)
	file.store_var(PV3A)
	file.store_var(PCA)

	# Nested Arrays and Dictionaries.
	file.store_var(A2)
	file.store_var(A3)
	file.store_var(A4)
	file.store_var(A5)
	file.store_var(A6)
	file.store_var(A7)
	file.store_var(D2)
	file.store_var(D3)
	file.store_var(D4)
	file.store_var(D5)
	file.store_var(D6)
	file.store_var(D7)
	file.store_var(D8)

	# 32-bit/64-bit numbers
	file.store_var(D9)

	file.close()

	return ok


func write_config_file(path: String, encrypted: bool = false) -> bool:

	var ok: bool = true

	var config_file: ConfigFile = ConfigFile.new()

	config_file.set_value("section", "key", DATA)

	var err: int

	if encrypted:
		err = config_file.save_encrypted_pass(path, PASSWORD)
	else:
		err = config_file.save(path)

	if err == OK:
		print_debug("Successfully wrote file '%s'" % path)
	else:
		print_debug("Failed to write file '%s', error=%d" % [path, err])
		ok = false

	return ok


#test
func dump_object() -> void:
	O = Node2D.new()
	O.position = Vector2(1.0, 2.0)
	O.rotation = PI
	O.scale = Vector2(3.0, 4.0)
#	print_debug("O=%s %d %s" % [O, var2bytes(O, true).decode_var_size(0), var2bytes(O, true)])
	var bytes: PoolByteArray = var2bytes(O, true)
	print_debug("O=%s %s" % [O, bytes])
	var chars: String = ""
	for byte in bytes:
		chars += char(byte)
	print("chars=%s" % chars)
	var property_list: Array = O.get_property_list()
	for p in property_list:
		if p["usage"] & PROPERTY_USAGE_STORAGE != 0:
			print_debug("property=", p)
