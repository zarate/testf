package test
{
	import test.common.Test;

	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.getTimer;

	/**
	 * @author Juan Delgado
	 */
	public class IOTest extends Test
	{
		private static const TOTAL_ITERATIONS : int = 1000;
		
		override public function getName() : String
		{
			return "IOTest";
		}
		
		override public function run() : void
		{
			super.run();
			
			for(var x : int = 0; x < TOTAL_ITERATIONS; x++)
			{
				var file : File = File.createTempFile();
				
				var writeStream : FileStream = new FileStream();
				writeStream.open(file, FileMode.WRITE);
				writeStream.writeUTFBytes("This is file #" + x);
				writeStream.close();
				
				var appendStream : FileStream = new FileStream();
				appendStream.open(file, FileMode.APPEND);
				appendStream.writeUTFBytes("\nNew line");
				appendStream.close();					
				
				var readStream : FileStream = new FileStream();
				readStream.open(file, FileMode.READ);
				
				var content : String = readStream.readUTFBytes(readStream.bytesAvailable);
				readStream.close();
				
				file.deleteFile();
			}
						
			stop();
		}

		override protected function stop() : void
		{
			// Overriding stop here so I can add the end time as part of the human
			// readable result before dispatching the _finishedSignal signal.
			
			endTime = getTimer();

			humanReadableResult = "Creating " + TOTAL_ITERATIONS + " files took " + (endTime - initTime) + " ms";
			
			_finishedSignal.dispatch(this);
		}
	}
}
