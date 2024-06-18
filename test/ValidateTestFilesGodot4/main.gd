extends Node

# Directory for test files.
@export var dir_readable: String = "res://test_data"
@export var dir_writable: String = "user://"

# Password for encrypted files.
const PASSWORD: String = "godot"

# Test files created in Godot 3, using store_var().
const FILENAME_GODOT3: String = "/godot3.dat"
const FILENAME_GODOT3_ENCRYPTED: String = "/godot3_encrypted.dat"

# Test files created in Godot 3 using ConfigFile.
const FILENAME_GODOT3_CONFIG_FILE: String = "/godot3_config_file.txt"
const FILENAME_GODOT3_CONFIG_FILE_ENCRYPTED: String = "/godot3_config_file_encrypted.dat"

# Test files created in Godot 4, using store_var().
const FILENAME_GODOT4: String = "/godot4.dat"
const FILENAME_GODOT4_ENCRYPTED: String = "/godot4_encrypted.dat"

# Test files created in Godot 4, using ConfigFile.
const FILENAME_GODOT4_CONFIG_FILE: String = "/godot4_config_file.txt"
const FILENAME_GODOT4_CONFIG_FILE_ENCRYPTED: String = "/godot4_config_file_encrypted.dat"

var path_godot3: String
var path_godot3_encrypted: String
var path_godot3_config_file: String
var path_godot3_config_file_encrypted: String
var path_godot4: String
var path_godot4_encrypted: String
var path_godot4_config_file: String
var path_godot4_config_file_encrypted: String

var tmp_path: String

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
const Q: Quaternion = Quaternion(1.01, 2.02, 3.03, 4.04)
const AABB_: AABB = AABB(Vector3(1.0, 2.0, 3.0), Vector3(4.0, 5.0, 6.0))
const BASIS_: Basis = Basis(Vector3.LEFT, Vector3.RIGHT, Vector3.UP)
const T3D: Transform3D = Transform3D(BASIS_, Vector3.DOWN)
const C: Color = Color.PURPLE
const NP: NodePath = NodePath("Node2D/Sprite17")
const RID_: RID = RID() #TODO: Give this a value?
var O: Object = Node.new() #TODO: Give this a value?
const D: Dictionary = {"a": 15, "b": 30}
const A: Array = [3, 4]
const PBA: PackedByteArray = [17, 99]
const PIA: PackedInt32Array = [9, 8, 7]
const PFA: PackedFloat32Array = [2.5, 4.5, 6.5]
const PSA: PackedStringArray = ["a", "b", "c"]
const PV2A: PackedVector2Array = [Vector2.LEFT, Vector2.RIGHT]
const PV3A: PackedVector3Array = [Vector3.UP, Vector3.DOWN]
const PCA: PackedColorArray = [Color.RED, Color.BLUE, Color.GREEN]

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

@onready var button: Button = $Panel/RunTests
@onready var passed: Panel = $Panel/Passed
@onready var failed: Panel = $Panel/Failed
@onready var debug: Label = $Panel/Debug


func _ready() -> void:

	if Engine.get_version_info()["major"] != 4:
		button.hide()
		debug.text = "This project requires Godot 4."

	# Hide test result.
	passed.modulate.a = 0.0
	failed.modulate.a = 0.0

	button.focus_mode = Control.FOCUS_NONE
	button.pressed.connect(_on_button_pressed)

	#test
	#dump_object()


func _on_button_pressed() -> void:
	var ok: bool = true
	var tween: Tween

	button.disabled = true

	# Hide test result.
	tween = create_tween()
	tween.parallel().tween_property(passed, "modulate:a", 0.0, 1.0).set_trans(Tween.TRANS_EXPO)
	tween.parallel().tween_property(failed, "modulate:a", 0.0, 1.0).set_trans(Tween.TRANS_EXPO)
	await tween.finished

	# Initialize, run tests, cleanup.
	init_paths()
	write_test_files()
	if not run_tests():
		ok = false
	delete_temporary_files()

	# Show test result.
	var panel: Panel = passed if ok else failed
	tween = create_tween()
	tween.tween_property(panel, "modulate:a", 1.0, 1.0).set_trans(Tween.TRANS_EXPO)
	await tween.finished

	button.disabled = false


func init_paths() -> void:
	# These files must already exist.
	path_godot3 = dir_readable + FILENAME_GODOT3
	path_godot3_encrypted = dir_readable + FILENAME_GODOT3_ENCRYPTED
	path_godot3_config_file = dir_readable + FILENAME_GODOT3_CONFIG_FILE
	path_godot3_config_file_encrypted = dir_readable + FILENAME_GODOT3_CONFIG_FILE_ENCRYPTED

	# These files must be creatable/writable/deletable.
	# They're only used for additional testing of CryptGodot3.is_encrypted_godot3_file().
	path_godot4 = dir_writable + FILENAME_GODOT4
	path_godot4_encrypted = dir_writable + FILENAME_GODOT4_ENCRYPTED
	path_godot4_config_file = dir_writable + FILENAME_GODOT4_CONFIG_FILE
	path_godot4_config_file_encrypted = dir_writable + FILENAME_GODOT4_CONFIG_FILE_ENCRYPTED

	# Create path names for temporary files.
	randomize()
	tmp_path = make_tmp_path_name()
	#debug.text = tmp_path


func write_test_files() -> void:
	write_godot4_file(path_godot4)
	write_godot4_file(path_godot4_encrypted, true)
	write_godot4_config_file(path_godot4_config_file)
	write_godot4_config_file(path_godot4_config_file_encrypted, true)


# Write test data to file.
func write_godot4_file(path: String, encrypted: bool = false) -> void:

	var file: FileAccess
	var err: Error

	if encrypted:
		file = FileAccess.open_encrypted_with_pass(path, FileAccess.WRITE, PASSWORD)
	else:
		file = FileAccess.open(path, FileAccess.WRITE)
	err = OK if file != null else FileAccess.get_open_error()
	if err == OK:
		#print("Successfully opened file '%s' for writing " % path)
		pass
	else:
		print_debug("Failed to open file '%s' for writing, error=%d" % [path, err])
		return

	file.store_var(I)
	file.store_8(I)
	file.store_16(I)
	file.store_32(I)
	file.store_64(I)
	file.store_var(F)
	file.store_double(F)
	file.store_float(F)
	file.store_real(F)
	file.store_var(B)
	file.store_var(S)
	file.store_pascal_string(S)
	file.store_var(V)
	file.store_var(A)
	file.store_csv_line(PSA)
	file.store_buffer(PBA)
	file.store_var(D)
	#file.store_var(D2)

	file.close()


func write_godot4_config_file(path: String, encrypted: bool = false) -> bool:

	var ok: bool = true

	var config_file: ConfigFile = ConfigFile.new()

	config_file.set_value("section", "key", DATA)

	var err: int

	if encrypted:
		err = config_file.save_encrypted_pass(path, PASSWORD)
	else:
		err = config_file.save(path)

	if err == OK:
		#print_debug("Successfully wrote file '%s'" % path)
		pass
	else:
		print_debug("Failed to write file '%s', error=%d" % [path, err])
		ok = false

	return ok


func run_tests() -> bool:
	var ok: bool = true

	# Test class FileAccessGodot3 with unencrypted file.
	if run_test(path_godot3):
		print("********** run_tests: ALL DATA TESTS PASSED for file '%s'" % path_godot3)
	else:
		ok = false
		print("********** run_tests: ONE OR MORE TESTS FAILED for file '%s'" % path_godot3)

	# Test class FileAccessGodot3 with encrypted file.
	if run_test(path_godot3_encrypted, true):
		print("********** run_tests: ALL DATA TESTS PASSED for file '%s'" % path_godot3_encrypted)
	else:
		ok = false
		print("********** run_tests: ONE OR MORE TESTS FAILED for file '%s'" % path_godot3_encrypted)

	# Test class ConfigFile with unencrypted file.
	# ConfigFile is Godot 3/4-compatible for unencoded (plain text) files.
	if run_config_file_test(path_godot3_config_file):
		print("********** run_tests: ALL DATA TESTS PASSED for file '%s'" % path_godot3_config_file)
	else:
		ok = false
		print("********** run_tests: ONE OR MORE TESTS FAILED for file '%s'" % path_godot3_config_file)

	# Test class ConfigFileGodot3 with encrypted file.
	if run_config_file_test(path_godot3_config_file_encrypted, true):
		print("********** run_tests: ALL DATA TESTS PASSED for file '%s'" % path_godot3_config_file_encrypted)
	else:
		ok = false
		print("********** run_tests: ONE OR MORE TESTS FAILED for file '%s'" % path_godot3_config_file_encrypted)

	# Test CryptGodot3.is_encrypted_godot3_file().
	if test_is_encrypted_godot3_file():
		print("********** run_tests: ALL TESTS PASSED for CryptGodot3.is_encrypted_godot3_file()")
	else:
		ok = false
		print("********** run_tests: ONE OR MORE TESTS FAILED for CryptGodot3.is_encrypted_godot3_file()")

	return ok


func test_is_encrypted_godot3_file() -> bool:

	var is_godot3_encrypted: bool
	var ok: bool = true

	is_godot3_encrypted = CryptGodot3.is_encrypted_godot3_file(path_godot3)
	if is_godot3_encrypted:
		print_debug("is_encrypted_godot3_file failed on '%s'" % path_godot3)
	ok = ok and not is_godot3_encrypted

	is_godot3_encrypted = CryptGodot3.is_encrypted_godot3_file(path_godot3_encrypted)
	if not is_godot3_encrypted:
		print_debug("is_encrypted_godot3_file failed on '%s'" % path_godot3_encrypted)
	ok = ok and is_godot3_encrypted

	is_godot3_encrypted = CryptGodot3.is_encrypted_godot3_file(path_godot3_config_file)
	if is_godot3_encrypted:
		print_debug("is_encrypted_godot3_file failed on '%s'" % path_godot3_config_file)
	ok = ok and not is_godot3_encrypted

	is_godot3_encrypted = CryptGodot3.is_encrypted_godot3_file(path_godot3_config_file_encrypted)
	if not is_godot3_encrypted:
		print_debug("is_encrypted_godot3_file failed on '%s'" % path_godot3_config_file_encrypted)
	ok = ok and is_godot3_encrypted

	is_godot3_encrypted = CryptGodot3.is_encrypted_godot3_file(path_godot4)
	if is_godot3_encrypted:
		print_debug("is_encrypted_godot3_file failed on '%s'" % path_godot4)
	ok = ok and not is_godot3_encrypted

	is_godot3_encrypted = CryptGodot3.is_encrypted_godot3_file(path_godot4_encrypted)
	if is_godot3_encrypted:
		print_debug("is_encrypted_godot3_file failed on '%s'" % path_godot4_encrypted)
	ok = ok and not is_godot3_encrypted

	is_godot3_encrypted = CryptGodot3.is_encrypted_godot3_file(path_godot4_config_file)
	if is_godot3_encrypted:
		print_debug("is_encrypted_godot3_file failed on '%s'" % path_godot4_config_file)
	ok = ok and not is_godot3_encrypted

	is_godot3_encrypted = CryptGodot3.is_encrypted_godot3_file(path_godot4_config_file_encrypted)
	if is_godot3_encrypted:
		print_debug("is_encrypted_godot3_file failed on '%s'" % path_godot4_config_file_encrypted)
	ok = ok and not is_godot3_encrypted

	return ok

func delete_temporary_files() -> void:
	var _err: Error = DirAccess.remove_absolute(tmp_path)
	#debug.text += " [%d]" % _err
	DirAccess.remove_absolute(path_godot4)
	DirAccess.remove_absolute(path_godot4_encrypted)
	DirAccess.remove_absolute(path_godot4_config_file)
	DirAccess.remove_absolute(path_godot4_config_file_encrypted)


# Open specified file path for reading, and return a new FileAccess object.
# Return null if the file could not be opened.
func open_file(path: String, encrypted: bool = false) -> FileAccess:

	var file: FileAccess
	var err: Error

	if encrypted:
		if CryptGodot3.is_encrypted_godot3_file(path):
			if CryptGodot3.reencrypt_with_pass(path, PASSWORD, tmp_path) != OK:
				return null
			#print_debug("tmp path='%s'" % file.get_path())
			file = FileAccess.open_encrypted_with_pass(tmp_path, FileAccess.READ, PASSWORD)
		else:
			file = FileAccess.open_encrypted_with_pass(path, FileAccess.READ, PASSWORD)
	else:
		file = FileAccess.open(path, FileAccess.READ)
	err = OK if file != null else FileAccess.get_open_error()
	if err != OK:
		print("Failed to open file '%s' for reading, error=%d" % [path, err])
		return null

	return file


# Perform data tests on the specified path.
# Return true if all tests pass.
func run_test(path: String, encrypted: bool = false) -> bool:

	#print_debug("run_test(%s)" % path)

	var err: Error
	var ok: bool = true

	var file: FileAccess = open_file(path, encrypted)
	if file == null:
		return false
	var file_godot3 := FileAccessGodot3.new(file)
	#print_debug("file_godot3=", file_godot3)

	# Retain this as a comment for future debugging use.
	#print_debug("err=%d type=%d pba=%s PBA=%s" % [err, typeof(pba), pba, PBA])

# Basic types

	var b: Variant = file_godot3.get_var()
	err = file.get_error()
	if not (err == OK and b is bool and b == B):
		print("Data test failed: B")
		ok = false

	var i: Variant = file_godot3.get_var()
	err = file.get_error()
	if not (err == OK and i is int and i == I):
		print("Data test failed: I")
		ok = false

	var i8: Variant = file.get_8()
	err = file.get_error()
	if not (err == OK and i8 is int and i8 == I):
		print("Data test failed: I8")
		ok = false

	var i16: Variant = file.get_16()
	err = file.get_error()
	if not (err == OK and i16 is int and i16 == I):
		print("Data test failed: I16")
		ok = false

	var i32: Variant = file.get_32()
	err = file.get_error()
	if not (err == OK and i32 is int and i32 == I):
		print("Data test failed: I32")
		ok = false

	var i64: Variant = file.get_64()
	err = file.get_error()
	if not (err == OK and i64 is int and i64 == I):
		print("Data test failed: I64")
		ok = false

	var f: Variant = file_godot3.get_var()
	err = file.get_error()
	if not (err == OK and f is float and f == F):
		print("Data test failed: F")
		ok = false

	var f_double: Variant = file.get_double()
	err = file.get_error()
	if not (err == OK and f_double is float and f_double == F):
		print("Data test failed: F_double")
		ok = false

	var f_float: Variant = file.get_float()
	err = file.get_error()
	if not (err == OK and f_float is float and f_float == F):
		print("Data test failed: F_float")
		ok = false

	var f_real: Variant = file.get_real()
	err = file.get_error()
	if not (err == OK and f_real is float and f_real == F):
		print("Data test failed: F_real")
		ok = false

	var s: Variant = file_godot3.get_var()
	err = file.get_error()
	if not (err == OK and s is String and s == S):
		print("Data test failed: S")
		ok = false

	var s_pascal_string: Variant = file.get_pascal_string()
	err = file.get_error()
	if not (err == OK and s_pascal_string is String and s_pascal_string == S):
		print("Data test failed: S_pascal_string")
		ok = false

	var v: Variant = file_godot3.get_var()
	err = file.get_error()
	if not (err == OK and v is Vector2 and v.x == V.x and v.y == V.y):
		print("Data test failed: V")
		ok = false

	var r2: Variant = file_godot3.get_var()
	err = file.get_error()
	if not (err == OK and r2 is Rect2 and r2 == R2):
		print("Data test failed: R2")
		ok = false

	var v3: Variant = file_godot3.get_var()
	err = file.get_error()
	if not (err == OK and v3 is Vector3 and v3 == V3):
		print("Data test failed: V3")
		ok = false

	var t2d: Variant = file_godot3.get_var()
	err = file.get_error()
	if not (err == OK and t2d is Transform2D and t2d == T2D):
		print("Data test failed: T2D")
		ok = false

	var p: Variant = file_godot3.get_var()
	err = file.get_error()
	if not (err == OK and p is Plane and p == P):
		print("Data test failed: P")
		ok = false

	var q: Variant = file_godot3.get_var()
	err = file.get_error()
	if not (err == OK and q is Quaternion and q == Q):
		print("Data test failed: Q")
		ok = false

	var aabb: Variant = file_godot3.get_var()
	err = file.get_error()
	if not (err == OK and aabb is AABB and aabb == AABB_):
		print("Data test failed: AABB_")
		ok = false

	var basis: Variant = file_godot3.get_var()
	err = file.get_error()
	if not (err == OK and basis is Basis and basis == BASIS_):
		print("Data test failed: BASIS_")
		ok = false

	var t3d: Variant = file_godot3.get_var()
	err = file.get_error()
	if not (err == OK and t3d is Transform3D and t3d == T3D):
		print("Data test failed: T3D")
		ok = false

	var c: Variant = file_godot3.get_var()
	err = file.get_error()
	if not (err == OK and c is Color and c == C):
		print("Data test failed: C")
		ok = false

	var np: Variant = file_godot3.get_var()
	err = file.get_error()
	if not (err == OK and np is NodePath and np == NP):
		print("Data test failed: NP")
		ok = false

	#var rid: Variant = file_godot3.get_var()
	#err = file.get_error()
	#if not (err == OK and rid is RID and rid.get_id() == RID_.get_id()):
		#print("Data test failed: RID_")
		##print_debug("err=%d type=%d rid=%s RID_=%s rid.get_id() RID_.get_id()" % [err, typeof(rid), rid, RID_, rid.get_id(), RID_.get_id()])
		##print_debug("err=%d type=%d rid=%s RID_=%s RID_.get_id()" % [err, typeof(rid), rid, RID_, RID_.get_id()])
		#print_debug("err=%d type=%d rid=%s RID_=%s" % [err, typeof(rid), rid, RID_])
		#ok = false

	#var o: Variant = file_godot3.get_var(true)
	#err = file.get_error()
	#if not (err == OK and o is Node2D and o == O):
		#print("Data test failed: O")
		#print_debug("err=%d type=%d o=%s O_=%s" % [err, typeof(o), o, O])
		#ok = false
	#else:
		#print_debug("O test passed")

	var d: Variant = file_godot3.get_var()
	err = file.get_error()
	if not (err == OK and d is Dictionary and objects_equal(d, D)):
		print("Data test failed: D")
		ok = false

	var a: Variant = file_godot3.get_var()
	err = file.get_error()
	if not (err == OK and a is Array and objects_equal(a, A)):
		print("Data test failed: A")
		ok = false

	var pba: Variant = file_godot3.get_var()
	err = file.get_error()
	if not (err == OK and pba is PackedByteArray and pba == PBA):
		print("Data test failed: PBA")
		ok = false

	var pba2: Variant = file.get_buffer(PBA.size())
	err = file.get_error()
	if not (err == OK and pba2 is PackedByteArray and pba2 == PBA):
		print("Data test failed: PBA2")
		ok = false

	var pia: Variant = file_godot3.get_var()
	err = file.get_error()
	if not (err == OK and pia is PackedInt32Array and pia == PIA):
		print("Data test failed: PIA")
		ok = false

	var pfa: Variant = file_godot3.get_var()
	err = file.get_error()
	if not (err == OK and pfa is PackedFloat32Array and pfa == PFA):
		print("Data test failed: PFA")
		ok = false

	var psa: Variant = file_godot3.get_var()
	err = file.get_error()
	if not (err == OK and psa is PackedStringArray and psa == PSA):
		print("Data test failed: PSA")
		ok = false

	var psa2: Variant = file.get_csv_line()
	err = file.get_error()
	if not (err == OK and psa2 is PackedStringArray and psa2 == PSA):
		print("Data test failed: PSA2")
		ok = false

	var pv2a: Variant = file_godot3.get_var()
	err = file.get_error()
	if not (err == OK and pv2a is PackedVector2Array and pv2a == PV2A):
		print("Data test failed: PV2A")
		ok = false

	var pv3a: Variant = file_godot3.get_var()
	err = file.get_error()
	if not (err == OK and pv3a is PackedVector3Array and pv3a == PV3A):
		print("Data test failed: PV3A")
		ok = false

	var pca: Variant = file_godot3.get_var()
	err = file.get_error()
	if not (err == OK and pca is PackedColorArray and pca == PCA):
		print("Data test failed: PC")
		ok = false

# Nested Arrays and Dictionaries.

	var a2: Variant = file_godot3.get_var()
	err = file.get_error()
	if not(err == OK and a2 is Array and objects_equal(a2, A2)):
		print("Data test failed: A2")
		ok = false

	var a3: Variant = file_godot3.get_var()
	err = file.get_error()
	if not(err == OK and a3 is Array and objects_equal(a3, A3)):
		print("Data test failed: A3")
		ok = false

	var a4: Variant = file_godot3.get_var()
	err = file.get_error()
	if not(err == OK and a4 is Array and objects_equal(a4, A4)):
		print("Data test failed: A4")
		ok = false

	var a5: Variant = file_godot3.get_var()
	err = file.get_error()
	if not(err == OK and a5 is Array and objects_equal(a5, A5)):
		print("Data test failed: A5")
		ok = false

	var a6: Variant = file_godot3.get_var()
	err = file.get_error()
	if not(err == OK and a6 is Array and objects_equal(a6, A6)):
		print("Data test failed: A6")
		ok = false

	var a7: Variant = file_godot3.get_var()
	err = file.get_error()
	if not(err == OK and a6 is Array and objects_equal(a7, A7)):
		print("Data test failed: A7")
		ok = false

	var d2: Variant = file_godot3.get_var()
	err = file.get_error()
	if not(err == OK and d2 is Dictionary and objects_equal(d2, D2)):
		print("Data test failed: D2")
		ok = false

	var d3: Variant = file_godot3.get_var()
	err = file.get_error()
	if not(err == OK and d3 is Dictionary and objects_equal(d3, D3)):
		print("Data test failed: D3")
		ok = false

	var d4: Variant = file_godot3.get_var()
	err = file.get_error()
	if not(err == OK and d4 is Dictionary and objects_equal(d4, D4)):
		print("Data test failed: D4")
		ok = false

	var d5: Variant = file_godot3.get_var()
	err = file.get_error()
	if not(err == OK and d5 is Dictionary and objects_equal(d5, D5)):
		print("Data test failed: D5")
		ok = false

	var d6: Variant = file_godot3.get_var()
	err = file.get_error()
	if not(err == OK and d6 is Dictionary and objects_equal(d6, D6)):
		print("Data test failed: D6")
		ok = false

	var d7: Variant = file_godot3.get_var()
	err = file.get_error()
	if not(err == OK and d7 is Dictionary and objects_equal(d7, D7)):
		print("Data test failed: D7")
		ok = false

	var d8: Variant = file_godot3.get_var()
	err = file.get_error()
	if not(err == OK and d8 is Dictionary and objects_equal(d8, D8)):
		print("Data test failed: D8")
		ok = false

	# 32-bit/64-bit numbers

	var d9: Variant = file_godot3.get_var()
	err = file.get_error()
	if not(err == OK and d9 is Dictionary and objects_equal(d9, D9)):
		print("Data test failed: D9")
		ok = false

	#print_debug("path=%s encrypted=%s" % [file.get_path(), encrypted])

	file.close()

	return ok


# Perform data tests on the specified path.
# Return true if all tests pass.
func run_config_file_test(path: String, encrypted: bool = false) -> bool:

	var config_file: ConfigFile = ConfigFile.new()

	var err: Error

	if encrypted:
		if CryptGodot3.is_encrypted_godot3_file(path):
			err = ConfigFileGodot3.load_encrypted_pass(config_file, path, PASSWORD)
			if err != OK:
				print_debug("Failed to convert file '%s', error=%d" % [path, err])
				return false
		else:
			err = config_file.load_encrypted_pass(path, PASSWORD)
	else:
		err = config_file.load(path)

	if err == OK:
		#print_debug("Successfully read file '%s'" % path)
		pass
	else:
		print_debug("Failed to read file '%s', error=%d" % [path, err])
		return false

	var data: Dictionary = config_file.get_value("section", "key")

	if data == null:
		print_debug("Failed to extract data from file")
		return false

	#print_debug("data=", data)

	var ok: bool = true

	if not data is Dictionary:
		print_debug("Data test failed: data type")
		ok = false

	if not data.has_all(DATA.keys()):
		print_debug("Data test failed: missing key(s)")
		ok = false

	if not (data["I"] is int and data["I"] == I):
		print_debug("Data test failed: I")
		ok = false

	if not (data["F"] is float and data["F"] == F):
		print_debug("Data test failed: F")
		ok = false

	if not (data["B"] is bool and data["B"] == B):
		print_debug("Data test failed: B")
		ok = false

	if not (data["S"] is String and data["S"] == S):
		print_debug("Data test failed: S")
		ok = false

	if not (data["V"] is Vector2 and data["V"].x == V.x and data["V"].y == V.y):
		print_debug("Data test failed: V")
		ok = false

	if not (data["A"] is Array and data["A"].size() == A.size()\
			and data["A"][0] == A[0] and data["A"][1] == A[1]):
		print_debug("Data test failed: A")
		ok = false

	if not (data["D"] is Dictionary and data["D"].size() == D.size()\
			and data["D"]["a"] == D["a"] and data["D"]["b"] == D["b"]):
		print_debug("Data test failed: D")
		ok = false

	return ok


# Perform deep comparison of Arrays or Dictionaries.
# 	a - Array or Dictionary
#	b - Array or Dictionary
# Return true if a == b.
func objects_equal(a: Variant, b: Variant) -> bool:

	if typeof(a) != typeof(b):
		return false

	if typeof(a) == TYPE_ARRAY:
		if a.size() != b.size():
			return false
		for i in range(a.size()):
			if not objects_equal(a[i], b[i]):
				return false
		return true

	elif typeof(a) == TYPE_DICTIONARY:
		if a.size() != b.size():
			return false
		for key in a.keys():
			if not (b.has(key) and objects_equal(a[key], b[key])):
				return false
		return true

	else:
		return a == b


func make_tmp_path_name() -> String:
	# Replace "." with "_" for better filename portability.
	var timestamp: String = str(Time.get_unix_time_from_system()).replace(".", "_")
	var random_value: int = randi() % 1_000_000
	return "%s/%s_%06d.tmp" % [dir_writable, timestamp, random_value]


#test
func dump_object() -> void:
	#test
	O = Node2D.new()
	O.position = Vector2(1.0, 2.0)
	O.rotation = PI
	O.scale = Vector2(3.0, 4.0)
	var bytes: PackedByteArray = var_to_bytes_with_objects(O)
	#print_debug("O=%s %d %s" % [O, bytes.decode_var_size(0), bytes])
	print_debug("O=%s %s" % [O, bytes])
	var chars: String = ""
	for byte in bytes:
		chars += char(byte)
	print("chars=%s" % chars)
	var property_list: Array = O.get_property_list()
	for p in property_list:
		if p["usage"] & PROPERTY_USAGE_STORAGE != 0:
			print_debug("property=", p)
