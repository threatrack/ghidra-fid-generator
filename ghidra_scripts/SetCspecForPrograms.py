#Set Compiler Spec in programs in a folder.
#@author 
#@category
#@keybinding 
#@menupath 
#@toolbar 

if currentProgram:
	raise Exception("ERROR: Must be run in a tool without a program loaded!")

root = askProjectFolder("Choose root folder for which a compiler should be forced")
should_cspec = askString("Compiler ID", "Set compiler of all programs to:", "gcc")

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
		program = file.getDomainObject(java.lang.Object(), True, False, monitor)
		try:
			id = program.startTransaction("SetCspecForPrograms.py: Set compiler")
			program.setCompiler(should_cspec)
			program.setLanguage(program.getLanguage(), ghidra.program.model.lang.CompilerSpecID(should_cspec), False, monitor)
		finally:
			program.endTransaction(id, True)
		program.save("Set compiler to: " + should_cspec, monitor)

