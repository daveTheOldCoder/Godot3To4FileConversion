# Godot3To4FileConversion

Godot3To4FileConversion is an addon consisting of three GDScript classes that enable certain files written in Godot 3 to be read in Godot 4.
		
Specifically, it provides solutions for these problems:<br>
* Encryption change in class ConfigFile<br>
* Encryption change in class File (Godot 3) / FileAccess (Godot 4)<br>
* File.store\_var()/FileAccess.get\_var() incompatibility due to changes in the enum Variant.Type values<br>
<br/>

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

* bool **is\_encrypted\_godot\_3\_file**(path: String) static

Return *true* if the file was created with encryption in Godot 3.

* Error **reencrypt**(read\_path: String, key: PackedByteArray, write\_path: String) static
 
Decrypt a file, which was written in Godot 3 using File.open\_encrypted(), File.open\_encrypted\_with\_pass(), ConfigFile.save\_encrypted() or ConfigFile.save\_encrypted\_pass(), and reencrypt the data to a second file, using FileAccess.open_encrypted().
 
* Error **reencrypt\_with\_pass**(read\_path: String, password: String, write\_path: String) static

Same as reencrypt(), except that the password is a String, rather than a PackedByteArray.


### FileAccessGodot3

Read data that was written with File.store_var() in Godot 3.

##### Methods

* FileAccessGodot3 **\_init**(file\_access: FileAccess, tmp\_path: String = "", key: PackedByteArray = [])

Class constructor.

* Variant **get\_var**()

Read data that was written in Godot 3 with File.store\_var().

## Installation

To use the addon in a Godot 4 project, copy the folder **addons/godot\_3\_to\_4\_file\_conversion** into the project folder.

## Test

The repository includes a test of the addon. If you want to repeat the test, import a Godot 3 project using the contents of the **CreateTestFilesGodot3** folder, and import a Godot 4 project using the contents of the **ValidateTestFilesGodot4** folder.

1. Open the **CreateTestFilesGodot3** project in the Godot editor using Godot 3. Select the Main node, and in the Inspector, set the property **Dir Writable** to a folder that will contain the test files. Then run the project and click the **Make Test Files** button. The **Succeeded** label will appear when the test files have been created.

2. Copy the test files into the **ValidateTestFilesGodot4** project folder.

3. Open the **ValidateTestFilesGodot4** project in the Godot editor using Godot 4. Select the Main node, and in the Inspector, set the property **Dir Readable** to the path of the test files created above, and set the property **Dir Writable** to a folder that will contain additional test files created by this project. Then run the project and click the **Run Tests** button. The **All Tests Passed** label will appear if the tests succeeded.
