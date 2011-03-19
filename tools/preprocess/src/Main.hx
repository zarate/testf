package;

/**
* This class reads the files of the src folder
* and generates variables that force the compiler
* to include all the tests that are later referenced 
* in the tests xml.
*
* Without doing this the compiler would simply ignore those
* test clases because they are not referenced on the 
* original code.
*/

class Main
{
	public static function main() : Void
	{
		var args = xa.Application.getArguments();
		
		if(xa.System.isWindows())
		{
			// This is a bug in xcross, read this for more info:
			// http://code.google.com/p/xcross/issues/detail?id=2
			args = args[0].split(" ");
		}
		
		var srcFolder = args[0];
		var preFolder = args[1];
		var testsFolder = args[2];
		var testsXml = args[3];
		var documentRoot = args[4];
		var xmlOutput = (args[5] == "true");
		
		if(!xa.Folder.isFolder(srcFolder))
		{
			xa.Application.exitError("Cannot find src folder: " + srcFolder);
		}
		
		var bits = preFolder.split(xa.System.getSeparator());
		var previous = "";
		
		for(i in 0...bits.length)
		{
			previous += bits[i];
			
			if(!xa.Folder.isFolder(previous))
			{
				xa.Folder.create(previous);
			}
			
			previous += xa.System.getSeparator();
		}
		
		if(xa.Folder.isFolder(preFolder))
		{
			xa.Folder.forceDelete(preFolder);
		}
		
		xa.Folder.copy(srcFolder, preFolder);
		
		if(!xa.File.isFile(documentRoot))
		{
			xa.Application.exitError("Cannot find document root: " + documentRoot);
		}
		
		var tests = xa.Search.search(testsFolder, filter);
		
		var autoText = "AUTO-GENERATED,  do not update by hand!\n";
		var forcedImports = "\t" + autoText;
		var forcedVars = "\t\t" + autoText;
		var testsXmlString = "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>\n<tests>\n";
		
		for(i in 0...tests.length)
		{
			// line below extracts the classpath from the full path of the file
			var classPath = tests[i].substr(preFolder.length + 1, tests[i].length - preFolder.length - 4).split(xa.System.getSeparator()).join(".");
			
			forcedImports += "\timport " + classPath + ";\n";
			forcedVars += "\t\tprivate var force_" + i + " : " + classPath + ";\n";
			testsXmlString += "\t<test>" + classPath + "</test>\n";
		}
		
		testsXmlString += "</tests>";
		
		var template = new haxe.Template(xa.File.read(documentRoot));
		
		var output  = template.execute({forcedImports: forcedImports, forcedVars: forcedVars});
		
		xa.File.write(documentRoot, output);
		
		if(xmlOutput)
		{
			var xmlOutputBits = testsXml.split(xa.System.getSeparator());
			var prevXmlOutput = "";
			
			for(i in 0...xmlOutputBits.length)
			{
				prevXmlOutput += xmlOutputBits[i];
				
				if(!xa.Folder.isFolder(prevXmlOutput) && prevXmlOutput.indexOf(".") == -1)
				{
					xa.Folder.create(prevXmlOutput);
				}
				
				prevXmlOutput += xa.System.getSeparator();
			}
			
			xa.File.write(testsXml, testsXmlString);
		}
	}
	
	private static function filter(path : String) : Bool
	{
		return xa.File.isFile(path);
	}
}