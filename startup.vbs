set shell = wscript.createobject("wscript.shell")

startupPath = shell.specialfolders("Startup")
f = startupPath + "\keyhac.lnk"

set shortcut = shell.createshortcut(f)
shortcut.TargetPath = "%LOCALAPPDATA%\MyApp\Keyhac\keyhac.exe"
shortcut.save
