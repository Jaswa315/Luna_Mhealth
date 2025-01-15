# luna_authoring_system

Luna Authoring System is the program to convert PPTX to .luna files.

# How to Create a .luna file from pptx input
**Last Updated:** January 14, 2025  
**Version:** Pre-Version 0.

1. **Open a terminal**, Navigate to `luna_mhealth_mobile/luna_authoring_system` directory.
2. Put your pptx file that you want to convert under `.luna` in `luna_authoring_system/assets`
3. In `luna_authoring_system/main.dart`, edit the line that says `'const String samplePPTName = [ your PPTX exact name here with .pptx extension in the name ]';`
4. In the terminal you opened, run `flutter create .`
5. In the terminal, run `flutter run`
6. Pick a platform. For now, we highly recommend picking **macos** or **windows**.
7. **To find your Luna file:**
    - If you are on a mac, please look in `Users/[ your mac username ]/Library/Containers/parser/Data/Documents`
    - If you are on Windows, files are generated under `C:\Users\[ your username ]\Documents`

**Extra note:** To see inside the file, change the extension name into zip and decompress it.
