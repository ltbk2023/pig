# Projekt Inzynierski - Gra

### What is it?

<p> The mobile educational game is designed to teach and promote the general subject of management. The program could be used by educational institutions and individual recipients. Players should be able to learn through play. The game will be available on the most popular operating systems (Android and iOS). </p>


### Exporting to Android

<p> 
This instruction was written in October of 2023. To build the game for Android you need the following:

1. Godot. We used Godot version 4.0.4 stable.

2. Android Studio. We used Android Studio command line tools win-10406996 with SHA-256 of 9b782a54d246ba5d207110fddd1a35a91087a8aaf4057e9df697b1cbc0ef60fc

3. Java Development Kit. We used Oracle OpenJDK 21.0.1.

4. Debug.keystore file. We created it using our Oracle OpenJDK.

This instruction assumes you have neither and contains a step by step instruction on how to obtain them.

First of all, we need to create Android Built Template.
1. Open the project in Godot editor.
2. In the menu bar, select Project -> Install Android Build Template…
3. Click the Manage Templates… button.
4. In the Export Template Manager window, click the "Download & install" button. 
5. After the download completes, click the Close button in the Export Template Manager window.
6. From the editor menubar, select Project -> Install Android Build Template…
7. A confirmation dialog will appear. Click the Install button.
8. The build template files will be stored in an android/build subdirectory that is relative to the project root directory.

After that, we install Java JDK:
1. Enter website https://jdk.java.net/
2. Chooose build for your platform.
3. Unpack it.
4. Add Java folder to your PATH variable as JAVA_HOME.
5. PATH change might require rebooting the system.


After that we download and install Android Studio command line tools only:
1. Go to https://developer.android.com/studio
2. Scroll down to "Command line tools only" and pick right platform.
3. Unpack the directory and place it somewhere convenient (eg. C:\cmdline-tools)
4. Using command line as administrator, enter <YOUR_PATH_HERE>\bin and type in command:
sdkmanager --sdk_root=YOUR_PATH_HERE "platform-tools" "build-tools;30.0.3" "platforms;android-31" "cmdline-tools;latest" "cmake;3.10.2.4988404" "ndk;21.4.7075529"
5. Confirm License Agreement

After that Android export preset is needed:
1. From the editor menu bar, select Project -> Export…
2. From the Export window, select in the top-right corner of the window the Add… dropdown menu, and then select the Android option
3. Customize export options if needed
4. Editor -> Editor Settings -> Export -> Android -> Android SDK Path: choose the path of cmdline-tools

Once done, we need debug.keystore file, which we create by:
1. Go to your JAVA_HOME\bin and type in command:
keytool -keyalg RSA -genkeypair -alias androiddebugkey -keypass android -keystore debug.keystore -storepass android -dname "CN=Android Debug,O=Android,C=US" -validity 9999 -deststoretype pkcs12
2. In Godot pick: Editor->Editor Settings->Export->Android->Debug Keystore->pick debug.keystore file created

To export the Godot project:
1. In Godot select Project->Export
2. Use created export profile, use custom options if necessary (we used default).
3. Click "Export the project".
</p>
</p>