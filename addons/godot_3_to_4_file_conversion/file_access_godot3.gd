class_name FileAccessGodot3
## Read data that was written with File.store_var() in Godot 3.
##
## This class is intended to solve the issue of the Variant.Type enums being
## renumbered between Godot 3 and Godot 4.
##[br][br]
## [b]Limitations[/b]
##[br][br]
## The variable type [RID] has not been tested. It is not known whether
## this class supports it.
##[br][br]
## The variable type [Object] is [b]not[/b] supported by this class.
##
## @tutorial: https://github.com/daveTheOldCoder/Godot3To4FileConversion#readme

## Error code. May be accessed externally, but should [b]not[/b] be modified.
var err: Error = OK

## Debug output level. May be modified externally.[br]
## 0 = None[br]
## 1 = Errors (recommended)[br]
## 2 = Decoded variables[br]
## 3 = More information[br]
## 4 = Maximum information[br]
var debug: int = 1

# For debug output. Should not be modified externally.
const _RECURSION_LEVEL_INDENT: String = ".. "
var _indent: String

# For internal use. Should not be modified externally.
var _file_access: FileAccess
var _tmp_path: String
var _tmp_file: FileAccess
var _key: PackedByteArray
var _rng: RandomNumberGenerator

## Godot 3 Variant Types
## [br][br]
## For internal use by this class.
## [br][br]
## References:[br]
##	[url]https://docs.godotengine.org/en/3.5/classes/class_%40globalscope.html#enum-globalscope-variant-type[/url][br]
##	[url]https://github.com/godotengine/godot/blob/3.5/core/variant.h[/url]
enum _Godot3_Variant_Type {
	TYPE_NIL = 0,
	TYPE_BOOL = 1,
	TYPE_INT = 2,
	TYPE_REAL = 3,
	TYPE_STRING = 4,
	TYPE_VECTOR2 = 5,
	TYPE_RECT2 = 6,
	TYPE_VECTOR3 = 7,
	TYPE_TRANSFORM2D = 8,
	TYPE_PLANE = 9,
	TYPE_QUAT = 10,
	TYPE_AABB = 11,
	TYPE_BASIS = 12,
	TYPE_TRANSFORM = 13,
	TYPE_COLOR = 14,
	TYPE_NODE_PATH = 15,
	TYPE_RID = 16,
	TYPE_OBJECT = 17,
	TYPE_DICTIONARY = 18,
	TYPE_ARRAY = 19,
	TYPE_RAW_ARRAY = 20,
	TYPE_INT_ARRAY = 21,
	TYPE_REAL_ARRAY = 22,
	TYPE_STRING_ARRAY = 23,
	TYPE_VECTOR2_ARRAY = 24,
	TYPE_VECTOR3_ARRAY = 25,
	TYPE_COLOR_ARRAY = 26,
}

# Mapping of Godot 3 Variant Type to Godot 4
#
# References:
#	https://docs.godotengine.org/en/4.1/classes/class_%40globalscope.html#enum-globalscope-variant-type
#	https://github.com/godotengine/godot/blob/4.1/core/extension/gdextension_interface.h
const _MAP_TYPE_3_TO_4: Dictionary = {
	_Godot3_Variant_Type.TYPE_NIL: TYPE_NIL,
	_Godot3_Variant_Type.TYPE_BOOL: TYPE_BOOL,
	_Godot3_Variant_Type.TYPE_INT: TYPE_INT,
	_Godot3_Variant_Type.TYPE_REAL: TYPE_FLOAT,
	_Godot3_Variant_Type.TYPE_STRING: TYPE_STRING,
	_Godot3_Variant_Type.TYPE_VECTOR2: TYPE_VECTOR2,
	_Godot3_Variant_Type.TYPE_RECT2: TYPE_RECT2,
	_Godot3_Variant_Type.TYPE_VECTOR3: TYPE_VECTOR3,
	_Godot3_Variant_Type.TYPE_TRANSFORM2D: TYPE_TRANSFORM2D,
	_Godot3_Variant_Type.TYPE_PLANE: TYPE_PLANE,
	_Godot3_Variant_Type.TYPE_QUAT: TYPE_QUATERNION,
	_Godot3_Variant_Type.TYPE_AABB: TYPE_AABB,
	_Godot3_Variant_Type.TYPE_BASIS: TYPE_BASIS,
	_Godot3_Variant_Type.TYPE_TRANSFORM: TYPE_TRANSFORM3D,
	_Godot3_Variant_Type.TYPE_COLOR: TYPE_COLOR,
	_Godot3_Variant_Type.TYPE_NODE_PATH: TYPE_NODE_PATH,
	_Godot3_Variant_Type.TYPE_RID: TYPE_RID,
	_Godot3_Variant_Type.TYPE_OBJECT: TYPE_OBJECT,
	_Godot3_Variant_Type.TYPE_DICTIONARY: TYPE_DICTIONARY,
	_Godot3_Variant_Type.TYPE_ARRAY: TYPE_ARRAY,
	_Godot3_Variant_Type.TYPE_RAW_ARRAY: TYPE_PACKED_BYTE_ARRAY,
	_Godot3_Variant_Type.TYPE_INT_ARRAY: TYPE_PACKED_INT32_ARRAY,
	_Godot3_Variant_Type.TYPE_REAL_ARRAY: TYPE_PACKED_FLOAT32_ARRAY,
	_Godot3_Variant_Type.TYPE_STRING_ARRAY: TYPE_PACKED_STRING_ARRAY,
	_Godot3_Variant_Type.TYPE_VECTOR2_ARRAY: TYPE_PACKED_VECTOR2_ARRAY,
	_Godot3_Variant_Type.TYPE_VECTOR3_ARRAY: TYPE_PACKED_VECTOR3_ARRAY,
	_Godot3_Variant_Type.TYPE_COLOR_ARRAY: TYPE_PACKED_COLOR_ARRAY,
}

# From core/io/marshalls.cpp
const ENCODE_MASK: int = 0xFF
const ENCODE_FLAG_64: int = 1 << 16
const ENCODE_FLAG_OBJECT_AS_ID: int = 1 << 16

class _VariantType:
	var type: Variant.Type
	var is_64: bool
	func _init(_type: Variant.Type, _is_64: bool):
		type = _type
		is_64 = _is_64

class _ConvertedElement:
	var content: PackedByteArray
	var offset: int
	func _init(_content: PackedByteArray, _offset: int):
		content = _content
		offset = _offset

## Class constructor.
## [br][br]
## The parameter [param file_access] is the return value of FileAccess.open(),
## FileAccess.open_encrypted() or FileAccess.open_encrypted_with_pass().
## [br][br]
## The optional parameter [param tmp_path] is the absolute path for the temporary file used by
## the get_var() method. Its default value is an empty String.
## [br][br]
## The optional parameter [param key] is the encryption key for the temporary file. Its length will
## be adjusted to 32 bytes, if needed, by truncation or zero-padding using
## PackedByteArray.resize(32). Its default value is an empty PackedByteArray.
## [br][br]
## If either optional parameter is omitted, or specified as its default value, an internal value
## will be generated using a timestamp and random number.
func _init(file_access: FileAccess, tmp_path: String = "", key: PackedByteArray = []) -> void:
	_rng = RandomNumberGenerator.new()
	_rng.randomize()
	_file_access = file_access
	_tmp_path = _make_tmp_path_name() if tmp_path.is_empty() else tmp_path
	if key.is_empty():
		_key = _make_key()
	else:
		key.resize(32)
		_key = key
	if debug >= 2:
		assert(not _RECURSION_LEVEL_INDENT.is_empty())
		_indent = ""

func _make_tmp_path_name() -> String:
	var cache_dir: String = "user://"
	# Replace "." with "_" for better filename portability.
	var timestamp: String = str(Time.get_unix_time_from_system()).replace(".", "_")
	var random_value: int = _rng.randi() % 1_000_000
	return "%s/%s_%06d.tmp" % [cache_dir, timestamp, random_value]


# Make buffer with length 32 containing random bytes.
func _make_key() -> PackedByteArray:
	var key: PackedByteArray =\
			str(Time.get_unix_time_from_system() * _rng.randf()).sha256_buffer()
	if debug >= 4:
		print_debug("%f %f %s %d" % [Time.get_unix_time_from_system(), _rng.randf(), key, key.size()])
	assert(key.size() == 32)
	return key


## Read data that was written in Godot 3 with File.store_var().
## [br][br]
## Creates and deletes a temporary file.
## The temporary file is placed in the directory "user://" with the extension ".tmp", and the
## filename is generated using a timestamp and a random number.
## The temporary file is encrypted. The password is generated using a timestamp
## and a random number.
## Either the path or encryption password may be overridden using parameters in the class
## constructor (see above).
## [br][br]
## [i]The parameter [param allow_objects] is not supported.[/i]
func get_var() -> Variant:

	if debug >= 4:
		print_debug("_tmp_path=%s, _key=%s" % [_tmp_path, _key])
	# Since the data in the file that's being accessed may be private, encrypt
	# the temporary file that contains a portion of that data.
	#
	# Since the file is encrypted, it has to be opened in WRITE mode, written,
	# closed, re-opened in READ mode and read. If the file were not encrypted,
	# it would only need to be opened once, in WRITE_READ mode, using seek()
	# to rewind the file for reading.

	_tmp_file = FileAccess.open_encrypted(_tmp_path, FileAccess.WRITE, _key)
	err = OK if _tmp_file != null else FileAccess.get_open_error()
	if err != OK:
		if debug >= 1:
			print_debug("Failed to open file '%s' for writing, error=%d" % [_tmp_path, err])
		return null
	elif debug >= 4:
		print_debug("Successfully opened file '%s' for writing" % _tmp_path)

	# Read a variable from _file_access and write converted variable to _tmp_file.
	_convert_variable()

	_tmp_file.close()

	_tmp_file = FileAccess.open_encrypted(_tmp_path, FileAccess.READ, _key)
	err = OK if _tmp_file != null else FileAccess.get_open_error()
	if err != OK:
		if debug >= 1:
			print_debug("Failed to open file '%s' for reading, error=%d" % [_tmp_path, err])
		return null
	elif debug >= 4:
		print_debug("Successfully opened file '%s' for reading" % _tmp_path)

	# Read converted variable from _tmp_file.
	var v: Variant = _tmp_file.get_var()
	if debug >= 4:
		print_debug("v=", v)

	_tmp_file.close()

	# Delete the temporary file so that the user doesn't have to delete it,
	# which makes the class easier to use.
	# I'm giving ease-of-use precedence over efficiency.
	DirAccess.remove_absolute(_tmp_path)

	return v


# Convert Godot 3 variant type to Godot 4.
func _convert_variable() -> void:

	# Length field: Length is four bytes.
	# The length includes the variant type field and the variable content.
	var var_length: int = _file_access.get_32()
	_tmp_file.store_32(var_length)

	if debug >= 3:
		print_debug("var_length=%d" % var_length)

	# Variant type field: Length is four bytes.
	var converted_variant_type: _VariantType =\
			_convert_variant_type(_file_access.get_32() as _Godot3_Variant_Type)
	var var_type: Variant.Type = converted_variant_type.type
	if converted_variant_type.is_64:
		var_type |= ENCODE_FLAG_64
	_tmp_file.store_32(var_type)

	if debug >= 3:
		print_debug("var_type=%08x" % var_type)

	# Variable content: Length is value of length field less four bytes.
	var var_content: PackedByteArray = _file_access.get_buffer(var_length - 4)

	if debug >= 3:
		print_debug("var_content length=%s" % var_content.size())

	if var_type == TYPE_ARRAY or var_type == TYPE_DICTIONARY:
		var buf: PackedByteArray = _convert_array_or_dictionary(var_type, var_content)
		_tmp_file.store_buffer(buf)
	else:
		_tmp_file.store_buffer(var_content)

		if debug >= 2:
			var var_size: int = var_content.decode_var_size(0)
			var var_data: PackedByteArray = var_content.slice(0, var_size)
			var var_value: Variant = var_content.decode_var(0)
			print_debug("%sVariant value=%s size=%d data=%s" %\
					[_indent, var_value, var_size, var_data])

	if debug >= 4:
	# Length field: Len
		print_debug("var_length=%d var_type=%08x var_content=%s" %\
				[var_length, var_type, var_content])


func _convert_array_or_dictionary(var_type: Variant.Type, var_content: PackedByteArray) -> PackedByteArray:

	if debug >= 2:
		_indent += _RECURSION_LEVEL_INDENT
		print_debug("%senter level %d" %\
				[_indent, (_indent.length() / _RECURSION_LEVEL_INDENT.length())])

	assert(var_type == TYPE_ARRAY or var_type == TYPE_DICTIONARY)

	var offset: int = 0

	if debug >= 3:
		print_debug("var_content length=%d" % var_content.size())

	var num_elements: int = var_content.decode_s32(offset)
	offset += 4

	if debug >= 2:
		match var_type:
			TYPE_ARRAY:
				print_debug("%sArray, num elements=%d" % [_indent, num_elements])
			TYPE_DICTIONARY:
				print_debug("%sDictionary, num keys=%d" % [_indent, num_elements])

	var converted_element: _ConvertedElement

	for i in range(num_elements):
		# Process Array element or Dictionary key.
		converted_element = _convert_element(var_content, offset)
		var_content = converted_element.content
		offset = converted_element.offset

		if var_type == TYPE_DICTIONARY:
			# Process Dictionary value.
			converted_element = _convert_element(var_content, offset)
			var_content = converted_element.content
			offset = converted_element.offset

	if debug >= 2:
		print_debug("%sexit level %d" %\
				[_indent, (_indent.length() / _RECURSION_LEVEL_INDENT.length())])
		_indent = _indent.left(-_RECURSION_LEVEL_INDENT.length())

	return var_content


# Convert Array element, Dictionary key or Dictionary value.
func _convert_element(var_content: PackedByteArray, offset: int) -> _ConvertedElement:

	# Change stored Godot 4 variant type to Godot 4.
	var var_type_godot3: _Godot3_Variant_Type =\
			var_content.decode_s32(offset) as _Godot3_Variant_Type
	var converted_variant_type: _VariantType =\
			_convert_variant_type(var_type_godot3)
	var var_type: Variant.Type = converted_variant_type.type
	if converted_variant_type.is_64:
		var_type |= ENCODE_FLAG_64
	if debug >= 3:
		print_debug("variant type converted from %08x to %08x" % [var_type_godot3, var_type])
	var_content.encode_s32(offset, var_type)

	if debug >= 2:
		match var_type & ENCODE_MASK:
			TYPE_ARRAY:
				var num_elements: int = var_content.decode_s32(offset+4)
				print_debug("%sArray, num elements=%d" % [_indent, num_elements])
			TYPE_DICTIONARY:
				var num_elements: int = var_content.decode_s32(offset+4)
				print_debug("%sDictionary, num keys=%d" % [_indent, num_elements])
			TYPE_BOOL:
				var var_size: int = var_content.decode_var_size(offset)
				var var_data: PackedByteArray = var_content.slice(offset, offset+var_size)
				var var_value: bool = var_content.decode_var(offset)
				print_debug("%sbool value=%s size=%d data=%s" % [_indent, var_value, var_size, var_data])
			TYPE_INT:
				var var_size: int = var_content.decode_var_size(offset)
				var var_data: PackedByteArray = var_content.slice(offset, offset+var_size)
				var var_value: int = var_content.decode_var(offset)
				print_debug("%sint value=%s size=%d data=%s" % [_indent, var_value, var_size, var_data])
			TYPE_FLOAT:
				var var_size: int = var_content.decode_var_size(offset)
				var var_data: PackedByteArray = var_content.slice(offset, offset+var_size)
				var var_value: float = var_content.decode_var(offset)
				print_debug("%sfloat value=%s size=%d data=%s" % [_indent, var_value, var_size, var_data])
			TYPE_VECTOR2:
				var var_size: int = var_content.decode_var_size(offset)
				var var_data: PackedByteArray = var_content.slice(offset, offset+var_size)
				var var_value: Vector2 = var_content.decode_var(offset)
				print_debug("%sVector2 value=%s size=%d data=%s" % [_indent, var_value, var_size, var_data])
			TYPE_STRING:
				var var_size: int = var_content.decode_var_size(offset)
				var var_data: PackedByteArray = var_content.slice(offset, offset+var_size)
				var var_value: String = var_content.decode_var(offset)
				print_debug("%sString value='%s' size=%d data=%s" % [_indent, var_value, var_size, var_data])
			_:
				var var_size: int = var_content.decode_var_size(offset)
				var var_data: PackedByteArray = var_content.slice(offset, offset+var_size)
				#var var_value: Variant= var_content.decode_var(offset)
				print_debug("%sVariant size=%d" % [_indent, var_size])

	if (var_type & ENCODE_MASK) == TYPE_ARRAY or (var_type & ENCODE_MASK) == TYPE_DICTIONARY:
		# Perform indirect recursive call to convert element that's an Array or Dictionary.
		# Use offset+4 to skip over type field.
		var buf: PackedByteArray = _convert_array_or_dictionary(var_type, var_content.slice(offset + 4))

		# Copy conversion result back into original buffer.
		# Use offset+4 to skip over type field.
		for j in range(buf.size()):
			var_content[offset + 4 + j] = buf[j]

	# Skip over variable's content.
	var var_size: int = var_content.decode_var_size(offset)
	offset += var_size

	return _ConvertedElement.new(var_content, offset)


# Convert variant type from Godot 3 to Godot 4.
func _convert_variant_type(var_type_godot3: _Godot3_Variant_Type) -> _VariantType:

	var is_64: bool = (var_type_godot3 & ENCODE_FLAG_64) != 0
	var_type_godot3 &= ENCODE_MASK
	if debug >= 3:
		print_debug("is_64=%s" % is_64)

	if _MAP_TYPE_3_TO_4.has(var_type_godot3):
		return _VariantType.new(_MAP_TYPE_3_TO_4[var_type_godot3], is_64)
	else:
		# This condition indicates an invalid/corrupt file.
		if debug >= 1:
			print_debug("Unknown Godot 3 variant type: 0x%08x" % var_type_godot3)

		push_error("Unknown Godot 3 variant type: 0x%08x" % var_type_godot3)
		_tmp_file.close()
		assert(false)

		return _VariantType.new(TYPE_NIL, is_64)
