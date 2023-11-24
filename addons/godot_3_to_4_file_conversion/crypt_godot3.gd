class_name CryptGodot3
## Decrypt a file that was encrypted using Godot 3.
##
## @tutorial: https://github.com/daveTheOldCoder/Godot3To4FileConversion#readme


## Decrypt a file, which was written in Godot 3 using File.open_encrypted(),
## File.open_encrypted_with_pass(), ConfigFile.save_encrypted() or
## ConfigFile.save_encrypted_pass(), and reencrypt the data to a second file, using
## FileAccess.open_encrypted().
##[br][br]
## The parameter [param key] optimally should be 32 bytes long. If it's a different length,
## it will be truncated or zero-padded using PackedByteArray.resize(32).
##[br][br]
## Return OK if successful.
static func reencrypt(read_path: String, key: PackedByteArray, write_path: String) -> Error:

	var decrypted: PackedByteArray = decrypt(read_path, key)

	# Re-encrypt file.
	var file: FileAccess = FileAccess.open_encrypted(write_path, FileAccess.WRITE, key)
	var err: Error = OK if file != null else FileAccess.get_open_error()
	if err != OK:
		print_debug("reencrypt: Failed to open file '%s' for writing, error=%d" % [write_path, err])
		return err
	file.store_buffer(decrypted)
	file.close()

	return OK


## Decrypt a file, which was written in Godot 3 using File.open_encrypted(),
## File.open_encrypted_with_pass(), ConfigFile.save_encrypted() or
## ConfigFile.save_encrypted_pass(), and reencrypt the data to a second file,
## using FileAccess.open_encrypted().
##[br][br]
## The parameter [param password] will be converted to a PackedByteArray using
## String.md5_text().to_ascii_buffer().
##[br][br]
## Return OK if successful.
static func reencrypt_with_pass(read_path: String, password: String, write_path: String) -> Error:
	return reencrypt(read_path, password.md5_text().to_ascii_buffer(), write_path)


## Decrypt a file, which was written in Godot 3 using File.open_encrypted(),
## File.open_encrypted_with_pass(), ConfigFile.save_encrypted() or
## ConfigFile.save_encrypted_pass(), and return the decrypted data.
##[br][br]
## The parameter [param key] optimally should be 32 bytes long. If it's a different length,
## it will be truncated or zero-padded using PackedByteArray.resize(32).
##[br][br]
## The parameter [param ignore_md5] may be specified as [i]true[/i] to bypass the MD5 integrity
## check.
##[br][br]
## If an error occurred, an empty array will be returned.
static func decrypt(path: String, key: PackedByteArray, ignore_md5: bool = false) -> PackedByteArray:

	var file: FileAccess
	var err: Error

	file = FileAccess.open(path, FileAccess.READ)
	err = OK if file != null else FileAccess.get_open_error()
	if err != OK:
		print_debug("reencrypt_file: Failed to open file '%s' for reading, error=%d" % [path, err])
		return []

	# Read file.
	file.get_32() # magic, should be 0x47444543 ("GDEC")
	file.get_32() # mode, ignore
	var md5_stored: PackedByteArray = file.get_buffer(16)
	var length: int = file.get_64() # decrypted data length
	if length < 0 or length > (file.get_length() - file.get_position()):
		#print_debug("Length %d is invalid" % length)
		err = ERR_FILE_CORRUPT
		return []
	var length_rounded_up: int # encrypted data length, rounded up to block size
	if (length % 16) > 0:
		length_rounded_up = length + 16 - (length_rounded_up % 16)
	else:
		length_rounded_up = length
	var data: PackedByteArray = file.get_buffer(length_rounded_up)

	# Decrypt.
	var aes_context := AESContext.new()
	key.resize(32)
	err = aes_context.start(AESContext.MODE_ECB_DECRYPT, key)
	if err != OK:
		return []
	var decrypted: PackedByteArray = aes_context.update(data)
	aes_context.finish()
	decrypted.resize(length)

	file.close()

	if not ignore_md5:
		# Check MD5 hash.
		var hashing_context := HashingContext.new()
		err = hashing_context.start(HashingContext.HASH_MD5)
		if err != OK:
			return []
		err = hashing_context.update(decrypted)
		if err != OK:
			return []
		var md5_computed: PackedByteArray = hashing_context.finish()
		if md5_computed != md5_stored:
			#print_debug("reencrypt_file: MD5 check failed")
			err = ERR_FILE_CORRUPT
			return []

	return decrypted


## Decrypt a file, which was written in Godot 3 using File.open_encrypted(),
## File.open_encrypted_with_pass(), ConfigFile.save_encrypted() or
## ConfigFile.save_encrypted_pass(), and return the decrypted data.
##[br][br]
## The parameter [param password] will be converted to a PackedByteArray using
## String.md5_text().to_ascii_buffer().
##[br][br]
## The parameter [param ignore_md5] may be specified as [i]true[/i] to bypass the MD5 integrity
## check.
##[br][br]
## If an error occurred, an empty array will be returned.
static func decrypt_with_pass(path: String, password: String, ignore_md5: bool = false) -> PackedByteArray:
	return decrypt(path, password.md5_text().to_ascii_buffer(), ignore_md5)


## Return [i]true[/i] if the file was created with encryption in Godot 3.
##[br][br]
## This method is intended for distinguishing among valid Godot 3 and Godot 4 files
## whose contents were produced by File.store_*() in Godot 3, FileAccess.store_*() in
## Godot 4, or ConfigFile.save_*() in Godot 3 or Godot 4.
##[br][br]
## It might [b]not[/b] return an accurate result for other files.
static func is_encrypted_godot3_file(path: String) -> bool:
	#print_debug("is_encrypted_godot3_file, path '%s'" % path)
	# In this case, the password isn't needed or provided, and the MD5 check cannot be done without
	# the correct password, since the MD5 is computed on the decrypted data.
	var decrypted: PackedByteArray = decrypt(path, [], true)
	return not decrypted.is_empty()
