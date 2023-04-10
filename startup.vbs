set shell = wscript.createobject("wscript.shell")

startupPath = shell.specialfolders("Startup")
f = startupPath + "\Keyhac.lnk"

set shortcut = shell.createshortcut(f)
shortcut.TargetPath = "%LOCALAPPDATA%\Keyhac\keyhac.exe"
shortcut.save
