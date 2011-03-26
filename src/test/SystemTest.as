package test
{
	import flash.system.Capabilities;
	import test.common.Test;
	/**
	 * @author Juan Delgado
	 */
	public class SystemTest extends Test
	{
		override public function run() : void
		{
			super.run();
			
			humanReadableResult += "manufacturer: " + Capabilities.manufacturer + "\n";			humanReadableResult += "os: " + Capabilities.os + "\n";			humanReadableResult += "version: " + Capabilities.version + "\n";			humanReadableResult += "playerType: " + Capabilities.playerType + "\n";			humanReadableResult += "screenDPI: " + Capabilities.screenDPI + "\n";			humanReadableResult += "screenResolutionX: " + Capabilities.screenResolutionX + "\n";			humanReadableResult += "screenResolutionY: " + Capabilities.screenResolutionY + "\n";			humanReadableResult += "touchscreenType: " + Capabilities.touchscreenType + "\n";			humanReadableResult += "cpuArchitecture: " + Capabilities.cpuArchitecture + "\n";			humanReadableResult += "hasAccessibility: " + Capabilities.hasAccessibility + "\n";			humanReadableResult += "hasAudio: " + Capabilities.hasAudio + "\n";			humanReadableResult += "hasAudioEncoder: " + Capabilities.hasAudioEncoder + "\n";			humanReadableResult += "hasEmbeddedVideo: " + Capabilities.hasEmbeddedVideo + "\n";			humanReadableResult += "hasIME: " + Capabilities.hasIME + "\n";			humanReadableResult += "hasMP3: " + Capabilities.hasMP3 + "\n";			humanReadableResult += "hasPrinting: " + Capabilities.hasPrinting + "\n";			humanReadableResult += "hasScreenBroadcast: " + Capabilities.hasScreenBroadcast + "\n";			humanReadableResult += "hasScreenPlayback: " + Capabilities.hasScreenPlayback + "\n";			humanReadableResult += "hasStreamingAudio: " + Capabilities.hasStreamingAudio + "\n";			humanReadableResult += "hasStreamingVideo: " + Capabilities.hasStreamingVideo + "\n";			humanReadableResult += "hasTLS: " + Capabilities.hasTLS + "\n";			humanReadableResult += "hasVideoEncoder: " + Capabilities.hasVideoEncoder + "\n";			humanReadableResult += "isDebugger: " + Capabilities.isDebugger + "\n";			humanReadableResult += "isEmbeddedInAcrobat: " + Capabilities.isEmbeddedInAcrobat + "\n";			humanReadableResult += "language: " + Capabilities.language + "\n";			humanReadableResult += "localFileReadDisable: " + Capabilities.localFileReadDisable + "\n";			humanReadableResult += "maxLevelIDC: " + Capabilities.maxLevelIDC + "\n";			humanReadableResult += "pixelAspectRatio: " + Capabilities.pixelAspectRatio + "\n";			humanReadableResult += "screenColor: " + Capabilities.screenColor + "\n";			humanReadableResult += "supports32BitProcesses: " + Capabilities.supports32BitProcesses + "\n";			humanReadableResult += "supports64BitProcesses: " + Capabilities.supports64BitProcesses + "\n";
			
			result = Capabilities.serverString;
			
			stop();
		}

		override public function getName() : String
		{
			return "SystemTest";
		}
	}
}
