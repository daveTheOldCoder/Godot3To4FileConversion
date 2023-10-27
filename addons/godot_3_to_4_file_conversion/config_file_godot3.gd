class_name ConfigFileGodot3
## Read an encrypted file that was written with ConfigFile in Godot 3.
##
## @tutorial: https://github.com/daveTheOldCoder/Godot3To4FileConversion#readme


## Load a file, which was written in Godot 3 by ConfigFile.save_encrypted() or
## ConfigFile.save_encrypted_pass(), into the parameter [param config_file].
##[br][br]
## Return OK if successful.
static func load_encrypted(config_file: ConfigFile, path: String, key: PackedByteArray) -> Error:
	var decrypted: PackedByteArray = CryptGodot3.decrypt(path, key)
	return config_file.parse(decrypted.get_string_from_utf8()) if not decrypted.is_empty() else FAILED


## Load a file, which was written in Godot 3 by ConfigFile.save_encrypted() or
## ConfigFile.save_encrypted_pass(), into the parameter [param config_file].
##[br][br]
## The parameter [param password] will be converted to a PackedByteArray using
## String.md5_text().to_ascii_buffer().
##[br][br]
## Return OK if successful.
static func load_encrypted_pass(config_file: ConfigFile, path: String, password: String) -> Error:
	return load_encrypted(config_file, path, password.md5_text().to_ascii_buffer())

