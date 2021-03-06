/*
MIT license:
http://www.opensource.org/licenses/mit-license.php

Copyright (c) 2010 XAPI project contributors

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
*/

package xa.filters 
{
	import xa.filters.IFilter;
	import xa.File;
	
	public class ExtensionFilter implements IFilter
	{
		public function ExtensionFilter(extensions : Vector.<String>, copy : Boolean)
		{
			this.extensions = extensions;
			this.copy = copy;
		}
		
		public function filter(path : String) : Boolean
		{
			var _include : Boolean = false;
			
			if(xa.File.isFile(path))
			{
				var hasExtension : Boolean = xa.File.hasExtension(path, extensions);
				_include = (copy)? hasExtension : !hasExtension;
			}
			else
			{
				_include = true;
			}
			
			return _include;		
		}
		
		private var extensions : Vector.<String>;
		
		private var copy : Boolean;
	}
}