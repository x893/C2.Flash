using System;
using System.Collections.Generic;
using System.IO.Ports;
using System.Text;
using System.Threading;

namespace SendToC2
{
	public enum C2_ERROR
	{
		OK = 0,
		TIMEOUT,
		ERROR,
		UNKNOWN,
		CLOSE,
		EMPTY_DATA,
		DATA_NOT_EQUAL
	}
	public class C2Flash : SerialPort
	{
		private Queue<string> m_lines = new Queue<string>(100);
		private string m_data = string.Empty;
		private static char[] LF = new char[] { '\n' };
		private static char[] CR = new char[] { '\r' };

		public C2Flash(string portname)
			: this(portname, 115200)
		{
		}

		public C2Flash(string portname, int baud)
			: base(portname)
		{
			BaudRate = baud;
			DataBits = 8;
			Handshake = Handshake.None;
			NewLine = "\r";
			Parity = Parity.None;
			StopBits = StopBits.One;
			DataReceived += new SerialDataReceivedEventHandler(Data_Received);
			Responses = new List<string>(20);
		}

		public C2_ERROR Error
		{
			get;
			set;
		}

		public List<string> Responses
		{
			get;
			private set;
		}

		public string ResponseStrings
		{
			get
			{
				StringBuilder sb = new StringBuilder(1024);
				if (Responses != null && Responses.Count > 0)
					foreach (string line in Responses)
						sb.AppendLine(line);
				return sb.ToString();
			}
		}

		private void Data_Received(object sender, SerialDataReceivedEventArgs e)
		{
			SerialPort px = sender as SerialPort;
			if (px != null && px.BytesToRead > 0)
			{
				string data = px.ReadExisting();
				m_data += data;
				if (data.IndexOf('\n') >= 0)
				{
					string[] lines = m_data.Split(LF, StringSplitOptions.RemoveEmptyEntries);
					m_data = string.Empty;
					foreach (string line in lines)
					{
						if (line.EndsWith("\r"))
						{
							lock (m_lines)
							{
								if (m_lines.Count >= 90)
									m_lines.Dequeue();
								m_lines.Enqueue(line.TrimEnd(CR));
							}
						}
						else
							m_data += line;
					}
				}
			}
		}

		/// <summary>
		/// Send command to C2 flasher and wait response
		/// </summary>
		/// <param name="cmd">command</param>
		/// <param name="timeout_ms">#0 for timeout or =0 for infinite timeout</param>
		/// <returns>Error code</returns>
		public C2_ERROR SendCommand(string cmd, int timeout_ms)
		{
			string line;
			Error = C2_ERROR.CLOSE;
			if (IsOpen)
			{
				Error = C2_ERROR.UNKNOWN;

				lock (m_lines)
					m_lines.Clear();
				Responses.Clear();

				WriteLine(cmd);

				while (true)
				{
					line = null;
					lock (m_lines)
						if (m_lines.Count > 0)
							line = m_lines.Dequeue();
					if (line == null)
					{	// 5 ms time slice
						Thread.Sleep(5);
						if (timeout_ms != 0)
						{
							timeout_ms = (timeout_ms >= 5) ? timeout_ms - 5 : 0;
							if (timeout_ms == 0)
							{
								Error = C2_ERROR.TIMEOUT;
								break;
							}
						}
					}
					else if (string.IsNullOrEmpty(line))
						continue;
					else if (line == "READY")
					{
						if (Error == C2_ERROR.UNKNOWN)
							Error = C2_ERROR.OK;
						break;
					}
					else if (line.StartsWith("Result: "))
					{
						if (!line.StartsWith("Result: 00"))
							Error = C2_ERROR.ERROR;
						Responses.Add(line);
					}
					else
						Responses.Add(line);
				}
			}
			return Error;
		}

		public C2_ERROR SendCommand(string cmd)
		{
			return SendCommand(cmd, 5000);
		}

		private const string MEMORY_CONTENTS_ARE = "Memory contents are ";
		public byte[] FlashRead(uint address, int length)
		{
			string cmd = string.Format("c2fr {0:X} {1}", address, length);
			if (SendCommand(cmd) == C2_ERROR.OK)
				foreach (string line in Responses)
					if (line.StartsWith(MEMORY_CONTENTS_ARE))
					{
						string hex = line.Substring(MEMORY_CONTENTS_ARE.Length);
						if (hex.Length == length * 2)
						{
							byte[] bytes = new byte[length];
							for (int idx = 0; idx < length; idx++)
								bytes[idx] = Hex2Bin(hex.Substring(idx * 2, 2));
							return bytes;
						}
						break;
					}
			return null;
		}

		private byte Hex2Nibble(char ch)
		{
			if (ch >= '0' && ch <= '9')
				return (byte)(ch - '0');
			ch = Char.ToLower(ch);
			if (ch >= 'a' && ch <= 'f')
				return (byte)(ch - 'a' + 10);
			throw new ArgumentOutOfRangeException("ch", "Not a hex digit");
		}
		private byte Hex2Bin(string hex)
		{
			byte value = 0;
			value |= (byte)(Hex2Nibble(hex[0]) << 4);
			value |= (byte)(Hex2Nibble(hex[1]) << 0);
			return value;
		}

		private string Bin2Hex(byte[] bytes)
		{
			string hex = string.Empty;
			foreach (byte b in bytes)
				hex += string.Format("{0:X2}", b);
			return hex;
		}
		public C2_ERROR FlashWrite(uint Address, byte[] bytes)
		{
			if (bytes != null && bytes.Length > 0)
			{
				string cmd = string.Format("c2fw {0:X} {1}", Address, Bin2Hex(bytes));
				SendCommand(cmd);
				Thread.Sleep(500);
				return Error;
			}
			return C2_ERROR.EMPTY_DATA;
		}

		internal bool FlashCompare(byte[] bytes, uint Address)
		{
			if (bytes != null && bytes.Length > 0)
			{
				byte[] flash = FlashRead(Address, bytes.Length);
				if (flash == null || bytes.Length != flash.Length)
				{
					Error = C2_ERROR.EMPTY_DATA;
					return false;
				}
				for (int idx = 0; idx < bytes.Length; idx++)
					if (bytes[idx] != flash[idx])
					{
						Error = C2_ERROR.DATA_NOT_EQUAL;
						return false;
					}
				Thread.Sleep(500);
			}
			return true;
		}

		public C2_ERROR Initialize()
		{
			if (IsOpen == false)
				Open();
			return SendCommand("da");
		}
	}
}
