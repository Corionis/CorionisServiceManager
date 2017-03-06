Go to the [**Main Page**](index).<br/>
Go to the [**Documentation**](help).

Previous [Download Files](downloads).<br/>
Next [First Start](firststart) dialog.

# Using the installer
The MSI Installer is a standard Wiindows Installer-based MSI.

## Running the installer
 There are at least two ways to run the installer.

### Technique 1 - Run the MSI from a file explorer
Using a file explorer you can navigate to the directory containing the downloaded MSI file.

Then right-click the MSI file and select Install:<br/>
![Install MSI](res/ss-open-installer.jpg "Install MSI")<br/>

### Technique 2 - From a Command Prompt
Open a Command Prompt (DOS box) then enter:<br/>
<code> msiexec /i "Corionis Service Manager_{{ site.version }}.msi" </code>

Don't forget the double-quotes around the filename.

## Installer dialogs

### Welcome
![Welcome dialog](res/ss-install-welcome.jpg "Welcome dialog")<br/>
Click Next.

### Type of install
![Install type dialog](res/ss-install-type.jpg "Install type dialog")<br/>
Select the type of installation.
 * Only for me installs a shortcut only for the user, and the .ini file is kept in the user's APPDATA directory.
 * Everybody (all users) installs a shortcut for everyone, and the .ini file is shared.

### Install folder
![Install folder dialog](res/ss-install-folder.jpg "Install folder dialog")<br/>
Choose where to install CSM. In most cases the default is recommended.

### Install ready
![Install ready dialog](res/ss-install-ready.jpg "Install ready dialog")<br/>
Click Install when ready.

### Install finished
![Install finish dialog](res/ss-install-finish.jpg "Install finish dialog")<br/>
Uncheck the run option if you wish. Click Finish when done.

Next [First Start](firststart) dialog.<br/>
Previous [Download Files](downloads).

Go to the [**Documentation**](help).<br/>
Go to the [**Main Page**](index).

---

### Blog
