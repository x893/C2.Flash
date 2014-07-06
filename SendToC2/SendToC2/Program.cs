using System;
using System.Collections.Generic;
using System.IO;
using System.IO.Ports;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SendToC2
{
	class Program
	{
		static C2Flash c2flash = null;

		static void Main(string[] args)
		{
			int errorCode = 0;
			try
			{
				c2flash = new C2Flash("COM6", 115200);
				if (c2flash.Initialize() == C2_ERROR.OK)
				{
					FlashHexFile("EC3.hex");
				}
				else
				{
					Console.WriteLine(c2flash.ResponseStrings);
					errorCode = 1;
				}
			}
			catch (Exception ex)
			{
				Console.WriteLine(ex.Message);
				errorCode = 2;
			}
			if (c2flash != null && c2flash.IsOpen)
				c2flash.Close();
			c2flash = null;
			if (errorCode != 0)
			{
				Console.Write("Press any key to exit ");
				Console.ReadKey(true);
			}
			Environment.Exit(errorCode);
		}

		private static void FlashHexFile(string filename)
		{
			Exception exc = null;
			c2flash.Error = C2_ERROR.OK;

			if (!File.Exists(filename))
				throw new FileNotFoundException("File not found:", filename);

			string line;
			using (TextReader reader = File.OpenText(filename))
			{
				while ((line = reader.ReadLine()) != null)
				{
					if (string.IsNullOrEmpty(line) || line.Trim().StartsWith(":") == false)
						continue;
					c2flash.SendCommand("36 " + line);
					Console.WriteLine(c2flash.ResponseStrings);
					if (c2flash.Error != C2_ERROR.OK)
					{
						exc = new Exception(string.Format("Flash write error : {0}", c2flash.Error.ToString()));
						break;
					}
				}
				reader.Close();
			}
			if (exc != null)
				throw exc;
		}
	}
}
