# Godot3To4FileConversion

Godot3To4FileConversion is an addon consisting of three GDScript classes that enable certain files written in Godot 3 to be read in Godot 4.
		
Specifically, it provides solutions for these problems:<br>
* Encryption change in class ConfigFile<br>
* Encryption change in class File (Godot 3) / FileAccess (Godot 4)<br>
* File.store\_var()/FileAccess.get\_var() incompatibility due to changes in the enum Variant.Type values<br>

Tested in Godot 4.0.4-stable, 4.1.4-stable, 4.2.2-stable and 4.3-beta1, using test files created in Godot 3.5.3-stable and 3.6-beta5.

## Classes

Each of these classes has GDScript documentation comments, so that detailed information about the class is available within the Godot editor when the addon is present. To view that information, press F1 or click the Search Help icon, then type the class name.

### ConfigFileGodot3

Read an encrypted file that was written with ConfigFile in Godot 3.

##### Methods

* Error **load\_encrypted**(config\_file: ConfigFile, path: String, key: PackedByteArray) static

Load a file, which was written in Godot 3 by ConfigFile.save\_encrypted() or ConfigFile.save\_encrypted\_pass(), into the parameter *config\_file*.

* Error **load\_encrypted\_pass**(config\_file: ConfigFile, path: String, password: String) static

Same as load\_encrypted(), except that the password is a String, rather than a PackedByteArray.

 
### CryptGodot3

Decrypt a file that was encrypted using Godot 3.

##### Methods

* PackedByteArray **decrypt**(path: String, key: PackedByteArray, ignore\_md5: bool = false) static

Decrypt a file, which was written in Godot 3 using File.open\_encrypted(), File.open\_encrypted\_with\_pass(),  ConfigFile.save\_encrypted() or ConfigFile.save\_encrypted_pass(), and return the decrypted data.

* PackedByteArray **decrypt\_with\_pass**(path: String, password: String, ignore\_md5: bool = false) static

Same as decrypt(), except that the password is a String, rather than a PackedByteArray.

* bool **is\_encrypted\_godot3\_file**(path: String) static

Return *true* if the file was created with encryption in Godot 3.

* Error **reencrypt**(read\_path: String, key: PackedByteArray, write\_path: String) static
 
Decrypt a file, which was written in Godot 3 using File.open\_encrypted(), File.open\_encrypted\_with\_pass(), ConfigFile.save\_encrypted() or ConfigFile.save\_encrypted\_pass(), and reencrypt the data to a second file, using FileAccess.open_encrypted().
 
* Error **reencrypt\_with\_pass**(read\_path: String, password: String, write\_path: String) static

Same as reencrypt(), except that the password is a String, rather than a PackedByteArray.


### FileAccessGodot3

Read data that was written with File.store_var() in Godot 3.

##### Limitations

* The variable type **RID** has not been tested. It is not known whether this class supports it.
* The variable type **Object** is *not* supported by this class.
* The **FileAccessGodot3.get_var()** method creates a temporary file, so the platform has to support file creation/writing/deletion.

##### Methods

* FileAccessGodot3 **\_init**(file\_access: FileAccess, tmp\_path: String = "", key: PackedByteArray = [])

Class constructor.

* Variant **get\_var**()

Read data that was written in Godot 3 with File.store\_var().

## Installation

To use this addon in a Godot 4 project, copy the folder **addons/godot\_3\_to\_4\_file\_conversion/** into the project folder.

If installing from the Godot Editor AssetLib tab, only that folder needs to be installed.

## Examples

Here are some examples of using these classes. For brevity, the code here has no error checks. In practice, checking method calls for errors is usually desirable.

### Example 1

* Read an unencrypted Godot 3 file written using File.store\_var(), using FileAccessGodot3.get\_var().

Godot 3 code that creates an unencrypted file using File and the store\_*() methods:

	var i: int = 99
	var f: float = 1.5
	var s: String = "Hello"
	var j: int = -2
	var a: Array = [2, 4, 6]
	var d: Dictionary = {"a": 100, "b": 200}
	
	var file := File.open("user://test_g3.dat", File.WRITE)

	file.store_var(i)
	file.store_float(f)
	file.store_var(s)
	file.store_32(j)
	file.store_var(a)
	file.store_var(d)

	file.close()

Godot 4 code that reads the file:

	var file := FileAccess.open("user://test_g3.dat", FileAccess.READ)
	
	var file_g3 := FileAccessGodot3.new(file)

	var i: int = file_g3.get_var()
	var f: float = file.get_float()
	var s: String = file_g3.get_var()
	var j: int = file.get_32()
	var a: Array = file_g3.get_var()
	var d: Dictionary = file_g3.get_var()
	
	file.close()

### Example 2

* Read an encrypted Godot 3 file written using File.store\_var(), using CryptGodot3.reencrypt\_with\_pass() and FileAccessGodot3.get\_var().

Godot 3 code that creates an encrypted file using File and the store\_*() methods:

	var i: int = 99
	var f: float = 1.5
	var s: String = "Hello"
	var j: int = -2
	var a: Array = [2, 4, 6]
	var d: Dictionary = {"a": 100, "b": 200}
	
	var file := File.open_encrypted_with_pass("user://test_g3.dat", File.WRITE, "secret")

	file.store_var(i)
	file.store_float(f)
	file.store_var(s)
	file.store_32(j)
	file.store_var(a)
	file.store_var(d)

	file.close()

Godot 4 code that reads the file:

	CryptGodot3.reencrypt_with_pass("user://test_g3.dat", "secret", "user://test_g4.dat")

	var file := FileAccess.open_encrypted_with_pass("user://test_g4.dat", FileAccess.READ, "secret")
	
	var file_g3 := FileAccessGodot3.new(file)

	var i: int = file_g3.get_var()
	var f: float = file.get_float()
	var s: String = file_g3.get_var()
	var j: int = file.get_32()
	var a: Array = file_g3.get_var()
	var d: Dictionary = file_g3.get_var()
	
	file.close()

### Example 3

* Read an encrypted Godot 3 file written using ConfigFile, using CryptGodot3.reencrypt\_with\_pass() and ConfigFile.

Godot 3 code that creates an encrypted file using ConfigFile:

	var d: Dictionary = {"a": 100, "b": 200}

	var config_file := ConfigFile.new()
	config_file.set_value("section", "key", d)
	config_file.save_encrypted_pass("user://test_g3.dat", "secret")

Godot 4 code that reads the file:

	CryptGodot3.reencrypt_with_pass("user://test_g3.dat", "secret", "user://test_g4.dat")

	var config_file := ConfigFile.new()
	ConfigFile.load_encrypted_pass("user://test_g4.dat", "secret")
	var data: Dictionary = config_file.get_value("section", "key")

### Example 4

* Read an encrypted Godot 3 file written using ConfigFile, using ConfigFileGodot3.load\_encrypted_pass(). This has the same result as the previous example, but doesn't create a converted file.

Godot 3 code that creates an encrypted file using ConfigFile:

	var d: Dictionary = {"a": 100, "b": 200}

	var config_file := ConfigFile.new()
	config_file.set_value("section", "key", d)
	config_file.save_encrypted_pass("user://test.dat", "secret")

Godot 4 code that reads the file:

	var config_file := ConfigFile.new()
	ConfigFileGodot3.load_encrypted_pass(config_file, "user://test.dat", "secret")
	var data: Dictionary = config_file.get_value("section", "key")

### Example 5

* Use CryptGodot3.is\_encrypted\_godot3_file() to check whether a file was encrypted using Godot 3.

```
if CryptGodot3.is_encrypted_godot3_file("user://test.dat"):
	print("File is an encrypted Godot 3 file")
else:
	print("File is not an encrypted Godot 3 file")
```

## Test

The repository includes a test of the addon. If you want to repeat the test, import a Godot 3 project using the contents of the **CreateTestFilesGodot3** folder, and import a Godot 4 project using the contents of the **ValidateTestFilesGodot4** folder.

1. Open the **CreateTestFilesGodot3** project in the Godot editor using Godot 3. Select the Main node, and in the Inspector, set the property **Dir Writable** to a folder that will contain the test files. Then run the project and click the **Make Test Files** button. The **Succeeded** label will appear when the test files have been created. The names of the test files are:
	* godot3.dat
	* godot3_encrypted.dat
	* godot3\_config\_file.txt
	* godot3\_config\_file\_encrypted.dat

2. Copy the test files into the **ValidateTestFilesGodot4** project folder.

3. Copy the folder **addons/godot\_3\_to\_4\_file\_conversion** into the **ValidateTestFilesGodot4** project folder.

3. Open the **ValidateTestFilesGodot4** project in the Godot editor using Godot 4. Select the Main node, and in the Inspector, set the property **Dir Readable** to the path of the test files created above, and set the property **Dir Writable** to a path that will contain additional test files created by this project. These paths may be the same. Then run the project and click the **Run Tests** button. The **All Tests Passed** label will appear if the tests succeeded.
