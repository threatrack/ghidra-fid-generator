#Search for false Compiler Spec in programs in a folder.
#@author 
#@category
#@keybinding 
#@menupath 
#@toolbar 

if currentProgram:
	raise Exception("ERROR: Must be run in a tool without a program loaded!")

root = askProjectFolder("Choose root folder to dump containing program's Language IDs and Compiler Spec")
should_cspec = askString("Compiler ID", "Show all programs with a Compiler ID other than:", "gcc")

monitor.initialize(0)
monitor.setIndeterminate(True)

for file in ghidra.framework.model.ProjectDataUtils.descendantFiles(root):
	if monitor.isCancelled():
		break
	path = file.getPathname()
	metadata = file.getMetadata()
	langid = metadata.get("Language ID")
	cspec = metadata.get("Compiler ID")
	if should_cspec != cspec:
		print path + "\t" + langid + "\t" + cspec
