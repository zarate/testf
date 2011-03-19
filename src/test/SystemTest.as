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
			
			result += "manufacturer: " + Capabilities.manufacturer + "\n";			result += "os: " + Capabilities.os + "\n";			result += "version: " + Capabilities.version + "\n";			result += "playerType: " + Capabilities.playerType + "\n";			result += "screenDPI: " + Capabilities.screenDPI + "\n";			result += "screenResolutionX: " + Capabilities.screenResolutionX + "\n";			result += "screenResolutionY: " + Capabilities.screenResolutionY + "\n";			result += "touchscreenType: " + Capabilities.touchscreenType + "\n";			result += "cpuArchitecture: " + Capabilities.cpuArchitecture + "\n";			result += "hasAccessibility: " + Capabilities.hasAccessibility + "\n";			result += "hasAudio: " + Capabilities.hasAudio + "\n";			result += "hasAudioEncoder: " + Capabilities.hasAudioEncoder + "\n";			result += "hasEmbeddedVideo: " + Capabilities.hasEmbeddedVideo + "\n";			result += "hasIME: " + Capabilities.hasIME + "\n";			result += "hasMP3: " + Capabilities.hasMP3 + "\n";			result += "hasPrinting: " + Capabilities.hasPrinting + "\n";			result += "hasScreenBroadcast: " + Capabilities.hasScreenBroadcast + "\n";			result += "hasScreenPlayback: " + Capabilities.hasScreenPlayback + "\n";			result += "hasStreamingAudio: " + Capabilities.hasStreamingAudio + "\n";			result += "hasStreamingVideo: " + Capabilities.hasStreamingVideo + "\n";			result += "hasTLS: " + Capabilities.hasTLS + "\n";			result += "hasVideoEncoder: " + Capabilities.hasVideoEncoder + "\n";			result += "isDebugger: " + Capabilities.isDebugger + "\n";			result += "isEmbeddedInAcrobat: " + Capabilities.isEmbeddedInAcrobat + "\n";			result += "language: " + Capabilities.language + "\n";			result += "localFileReadDisable: " + Capabilities.localFileReadDisable + "\n";			result += "maxLevelIDC: " + Capabilities.maxLevelIDC + "\n";			result += "pixelAspectRatio: " + Capabilities.pixelAspectRatio + "\n";			result += "screenColor: " + Capabilities.screenColor + "\n";			result += "supports32BitProcesses: " + Capabilities.supports32BitProcesses + "\n";			result += "supports64BitProcesses: " + Capabilities.supports64BitProcesses + "\n";
			
			stop();
		}

		override public function getName() : String
		{
			return "SystemTest";
		}
	}
}
