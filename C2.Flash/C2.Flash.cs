using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using System.IO.Ports;
using System.Threading;
using System.IO;
using System.Globalization;

namespace C2.Flash
{
	public enum ResponseCode : byte
	{
		INVALID_COMMAND = 0x00,
		COMMAND_NO_CONNECT = 0x01,
		COMMAND_LOCKED = 0x03,
		COMMAND_FAILED = 0x02,
		COMMAND_TIMEOUT = 0x04,
		COMMAND_BAD_DATA = 0x05,
		COMMAND_OK = 0x0D,
		COMMAND_DROP = 0x55,

		COMMAND_READ_01 = 0x81,
		COMMAND_READ_02 = 0x82,
		COMMAND_READ_03 = 0x83,
		COMMAND_READ_04 = 0x84,

		COMMAND_NO_RESPONSE = 0xFF,
		COMMAND_BAD_RESPONSE = 0xFE
	}

	public partial class frmMain : Form
	{
		#region Constants 
		const byte C2_CONNECT_TARGET = 0x20;
		const byte C2_DISCONNECT_TARGET = 0x21;
		const byte C2_DEVICE_ID = 0x22;
		const byte C2_UNIQUE_DEVICE_ID = 0x23;
		const byte C2_TARGET_GO = 0x24;
		const byte C2_TARGET_HALT = 0x25;

		const byte C2_READ_SFR = 0x28;
		const byte C2_WRITE_SFR = 0x29;
		const byte C2_READ_RAM = 0x2A;
		const byte C2_WRITE_RAM = 0x2B;
		const byte C2_READ_FLASH = 0x2E;
		const byte C2_WRITE_FLASH = 0x2F;
		const byte C2_ERASE_PAGE = 0x30;

		const byte C2_ADDRESS_WRITE = 0x38;
		const byte C2_ADDRESSREAD = 0x39;
		const byte C2_DATA_WRITE = 0x3A;
		const byte C2_DATAREAD = 0x3B;

		const byte C2_ERASE_FLASH_03 = 0x3C;
		const byte C2_ERASE_FLASH_04 = 0x3D;
		const byte C2_READ_XRAM = 0x3E;
		const byte C2_WRITE_XRAM = 0x3F;

		const byte GET_FIRMWARE_VERSION = 0x44;
		const byte SET_FPDAT_ADDRESS = 0x45;
		const byte GET_FPDAT_ADDRESS = 0x46;

		const byte COMMAND_DROP = 0x55;
		const byte COMMAND_NO_RESPONSE = 0xFF;
		const byte COMMAND_BAD_RESPONSE = 0xFE;
		#endregion

		#region Variables 
		private SerialPort port = null;
		private object locked = new object();
		Response activeResponse = null;
		private char[] COMMA = new char[] { ',' };
		private List<C2Device> devices = new List<C2Device>();
		#endregion

		public frmMain()
		{
			InitializeComponent();
		}

		public C2Device CurrentC2Device
		{
			get { return cbDevices.SelectedItem as C2Device; }
		}

		#region frmMain_Load(...) 
		private void frmMain_Load(object sender, EventArgs e)
		{
			foreach (string portName in SerialPort.GetPortNames())
			{
				cbPorts.Items.Add(portName);
				if (portName == "COM1")
					cbPorts.SelectedIndex = cbPorts.Items.Count - 1;
			}
			if (cbPorts.SelectedIndex < 0 && cbPorts.Items.Count > 0)
				cbPorts.SelectedIndex = 0;

			loadDeviceList();
		}
		#endregion

		#region loadDeviceList() and Helpers
		private void loadDeviceList()
		{
			try
			{
				devices.Clear();
				using (TextReader dl = new StreamReader(Path.Combine(Application.StartupPath, "DeviceList.txt")))
				{
					string line;
					int lineNum = 0;
					List<string> fields = null;

					while ((line = dl.ReadLine()) != null)
					{
						lineNum++;
						line = line.Trim();
						if (line.Length == 0 || (fields != null && (line.StartsWith("#") || line.StartsWith("\"#"))))
							continue;

						List<string> values = new List<string>();

						#region Parse to values

						string part = string.Empty;
						int state = 0;

						foreach (char c in line)
						{
							switch (state)
							{
								case 0:
									if (!Char.IsWhiteSpace(c))
									{
										if (c == '"')
											state = 2;		// Collect up to next " ("" replaced to single ")
										else if (c == ',')
										{
											values.Add(part.Trim());
											part = string.Empty;
										}
										else
										{
											part += c;
											state = 1;
										}
									}
									break;
								case 1:
									if (c == ',')
									{
										values.Add(part.Trim());
										part = string.Empty;
										state = 0;
									}
									else
										part += c;
									break;
								case 2:
									if (c == '"')
										state = 3;
									else
										part += c;
									break;
								case 3:
									if (c == '"')
									{
										part += '"';
										state = 2;
									}
									else
									{
										values.Add(part.Trim());
										part = string.Empty;
										if (c == ',')
											state = 0;
										else if (!Char.IsWhiteSpace(c))
											state = 10;
										else
											state = 4;
									}
									break;
								case 4:
									if (c == ',')
										state = 0;
									else if (!Char.IsWhiteSpace(c))
										state = 10;
									break;
							}
							if (state == 10)
								break;
						}

						if (state == 0 || state == 1 || state == 3)
						{
							if (part.Length > 0)
								values.Add(part.Trim());
						}
						else if (state != 4)
						{
							MessageBox.Show(string.Format("Bad line ({0}): {1}", lineNum, line));
							continue;
						}
						#endregion

						if (fields == null)
						{
							if (values.Count > 0)
								fields = values;
							else
							{
								MessageBox.Show("First line not contains fields name");
								break;
							}

							for (int i = 0; i < fields.Count; i++)
							{
								string field = fields[i];
								if (field == null)
									field = string.Empty;
								if (field.StartsWith("#"))
									field = field.Substring(1).Trim();
								if (field.Length == 0)
								{
									MessageBox.Show(string.Format("Empty field name at position {0}", i + 1));
									fields = null;
									break;
								}
								else
									fields[i] = field;
							}
							if (fields == null)
								break;

							continue;
						}

						C2Device device = new C2Device();
						bool scan = true;

						device.Name = parseString(values, fields, "Name", ref scan, true);
						device.ID = parseByte(values, fields, "ID", ref scan, true);
						device.ExtraID = parseByte(values, fields, "Extraid", ref scan, true);
						device.Version = parseInt(values, fields, "Version", ref scan, true);
						device.StringObserved = parseString(values, fields, "String observed", ref scan, false);
						device.FlashSize = parseInt(values, fields, "Flash size", ref scan, true);
						device.FlashSectorSize = parseInt(values, fields, "Flash sector Size", ref scan, true);
						device.XramSize = parseInt(values, fields, "Xram size", ref scan, true);
						device.ExternalBus = parseBool(values, fields, "External bus", ref scan, true);
						device.Tested = parseBool(values, fields, "Tested", ref scan, true);
						device.LockType = parseString(values, fields, "Lock Type", ref scan, true);
						device.Readlock = parseInt(values, fields, "Read lock", ref scan, true);
						device.WriteLock = parseInt(values, fields, "Write Lock", ref scan, true);
						device.SingleLock = parseInt(values, fields, "Single lock", ref scan, true);
						device.Bottom = parseInt(values, fields, "Bottom", ref scan, true);
						device.Top = parseInt(values, fields, "Top", ref scan, true);
						device.Present = parseBool(values, fields, "Present", ref scan, true);
						device.Start = parseInt(values, fields, "Start", ref scan, true);
						device.Length = parseInt(values, fields, "Length", ref scan, true);
						device.SectorSize = parseInt(values, fields, "Sector Size", ref scan, true);
						device.PagedSFR = parseBool(values, fields, "Paged SFR", ref scan, true);
						device.SFR_Page = parseInt(values, fields, "SFR_Page", ref scan, true);
						if (scan)
						{
							device.USBFIFOSize = parseInt(values, fields, "USB FIFO", ref scan, true);
							if (scan)
								device.USBFIFO = true;
							else
							{
								scan = true;
								device.USBFIFO = parseBool(values, fields, "USB FIFO", ref scan, true);
							}
						}
						device.DebugInterface = parseString(values, fields, "Debug Interface", ref scan, true);
						device.Cache = parseInt(values, fields, "Cache", ref scan, true);
						device.BP0L = parseString(values, fields, "BP0L", ref scan, true);
						device.BP0H = parseString(values, fields, "BP0H", ref scan, true);
						device.BP1L = parseString(values, fields, "BP1L", ref scan, true);
						device.BP1H = parseString(values, fields, "BP1H", ref scan, true);
						device.BP2L = parseString(values, fields, "BP2L", ref scan, true);
						device.BP2H = parseString(values, fields, "BP2H", ref scan, true);
						device.BP3L = parseString(values, fields, "BP3L", ref scan, true);
						device.BP3H = parseString(values, fields, "BP3H", ref scan, true);
						device.Comments = parseString(values, fields, "Comments", ref scan, false);
						device.FPREG = parseByte(values, fields, "FPREG", ref scan, false);
						if (device.FPREG == 0)
							device.FPREG = 0xAD;

						if (scan)
							devices.Add(device);
						else
						{
							MessageBox.Show(string.Format("DeviceList.txt has bad values at line:{0}.", lineNum));
							break;
						}
					}
					dl.Close();
				}
			}
			catch (Exception ex)
			{
				MessageBox.Show(ex.Message);
			}

			cbDevices.Items.Clear();
			foreach (C2Device device in devices)
			{
				cbDevices.Items.Add(device);
			}
		}

		private bool parseBool(List<string> values, List<string> fields, string field, ref bool scan, bool mandatory)
		{
			bool v = false;
			string sv = parseString(values, fields, field, ref scan, mandatory);
			if (scan && !string.IsNullOrEmpty(sv))
				scan = bool.TryParse(sv, out v);
			return false;
		}

		private int parseInt(List<string> values, List<string> fields, string field, ref bool scan, bool mandatory)
		{
			int v = 0;
			string sv = parseString(values, fields, field, ref scan, mandatory);
			if (scan && !string.IsNullOrEmpty(sv))
			{
				if (sv.StartsWith("0x", StringComparison.InvariantCultureIgnoreCase))
					scan = int.TryParse(sv.Substring(2), NumberStyles.HexNumber, null, out v);
				else
					scan = int.TryParse(sv, out v);
			}
			return v;
		}

		private byte parseByte(List<string> values, List<string> fields, string field, ref bool scan, bool mandatory)
		{
			byte v = 0;
			string sv = parseString(values, fields, field, ref scan, mandatory);
			if (scan && !string.IsNullOrEmpty(sv))
			{
				if (sv.StartsWith("0x", StringComparison.InvariantCultureIgnoreCase))
					scan = byte.TryParse(sv.Substring(2), NumberStyles.HexNumber, null, out v);
				else
					scan = byte.TryParse(sv, out v);
			}
			return v;
		}

		private string parseString(List<string> values, List<string> fields, string field, ref bool scan, bool mandatory)
		{
			if (scan)
			{
				int idx = fields.IndexOf(field);
				if (idx >= 0 && values.Count > idx)
				{
					string v = values[idx];
					if (string.IsNullOrEmpty(v))
					{
						if (mandatory)
							scan = false;
						return null;
					}
					return v;
				}
				if(mandatory)
					scan = false;
			}
			return null;
		}
		#endregion

		#region frmMain_FormClosed(...) 
		private void frmMain_FormClosed(object sender, FormClosedEventArgs e)
		{
			disconnect();
		}

		private void disconnect()
		{
			if (port != null)
			{
				lock (locked)
				{
					port.Close();
					port = null;
				}
			}
			groupC2.Enabled = false;
			btnStartStop.Text = "Connect";
			cbPorts.Enabled = true;
		}
		#endregion

		#region btnStartStop_Click(...) 
		private void btnStartStop_Click(object sender, EventArgs e)
		{
			if (port == null)
			{
				try
				{
					port = new SerialPort(cbPorts.Text);
					port.BaudRate = 115200;
					port.Handshake = Handshake.None;
					port.DtrEnable = cbDTREnable.Checked;
					port.Parity = Parity.None;
					port.StopBits = StopBits.Two;
					port.DataBits = 8;
					port.Open();
					port.DataReceived += new SerialDataReceivedEventHandler(port_DataReceived);

					if (Device_Connect() && C2_Connect_Target())
					{
						btnStartStop.Text = "Disconnect";
						cbPorts.Enabled = false;
						groupC2.Enabled = true;
						C2_Device_Info();
						return;
					}
				}
				catch (Exception ex)
				{
					MessageBox.Show(ex.Message);
				}
				disconnect();
			}
			else
			{
				C2_Disconnect_Target();
				disconnect();
			}
		}
		#endregion

		#region cbDTREnable_CheckedChanged(...) 
		private void cbDTREnable_CheckedChanged(object sender, EventArgs e)
		{
			if (port != null && cbDTREnable.Checked)
			{
				port.DtrEnable = !port.DtrEnable;
				port.DtrEnable = !port.DtrEnable;
			}
		}
		#endregion

		#region Device_Connect() 
		private bool Device_Connect()
		{
			Response response = sendCommand(2, GET_FIRMWARE_VERSION);
			return (
				response.Result == ResponseCode.COMMAND_OK &&
				response.Raw[0] == 0x44 &&
				response.Raw[1] == 0x06
				);
		}
		#endregion

		#region C2_Connect_Target() 
		private bool C2_Connect_Target()
		{
			Response response = sendCommand(0, C2_CONNECT_TARGET);
			return setStatus("C2_CONNECT_TARGET", response);
		}
		#endregion

		#region C2_Disconnect_Target() 
		private bool C2_Disconnect_Target()
		{
			return setStatus("C2_DISCONNECT_TARGET", sendCommand(0, C2_DISCONNECT_TARGET));
		}
		#endregion

		#region sendCommand(int response_length, params byte [] p) 
		private Response sendCommand(int response_length, params byte[] package)
		{
			return sendCommand(response_length, null, 0, 0, package);
		}

		private Response sendCommand(int response_length, byte[] data, int startIndex, int length, params byte[] package)
		{
			Response response = new Response(response_length);
			if (port != null)
			{
				Application.DoEvents();
				activeResponse = response;

				if (package != null && package.Length > 0)
				{
					port.Write(package, 0, package.Length);
				}
				if (data != null)
				{
					port.Write(data, startIndex, length);
				}
				bool result = response.WaitEvent.WaitOne(5000);
				activeResponse = null;
				if (!result)
					response.Result = ResponseCode.COMMAND_NO_RESPONSE;
			}
			else
			{
				response.Result = ResponseCode.COMMAND_DROP;
			}
			return response;
		}
		#endregion

		#region port_DataReceived(...) 

		private byte[] received = null;

		private void port_DataReceived(object sender, SerialDataReceivedEventArgs e)
		{
			SerialPort sp = sender as SerialPort;
			if (sp != null)
			{
				int bytes = sp.BytesToRead;
				if (bytes > 0)
				{
					byte[] data = new byte[bytes];
					sp.Read(data, 0, bytes);

					if (activeResponse != null && !activeResponse.Complete)
					{
						if (activeResponse.Raw == null)
						{
							activeResponse.Raw = data;
						}
						else
						{
							byte[] new_data = new byte[data.Length + activeResponse.Raw.Length];
							Array.Copy(activeResponse.Raw, 0, new_data, 0, activeResponse.Raw.Length);
							Array.Copy(data, 0, new_data, activeResponse.Raw.Length, data.Length);
							activeResponse.Raw = new_data;
						}
						if (activeResponse.Raw.Length > activeResponse.Length)
						{
							activeResponse.Result = (ResponseCode)activeResponse.Raw[activeResponse.Length];
							activeResponse.Complete = true;
							activeResponse.WaitEvent.Set();
						}
					}
				}
			}
		}
		#endregion

		#region btnC2Target_Click(...) 
		private void btnC2Target_Click(object sender, EventArgs e)
		{
			C2_Device_Info();
		}
		#endregion

		#region C2_Device_Info()
		private bool C2_Device_Info()
		{
			Revision.Text = UniqueID.Text = DeviceID.Text = "";
			Response response = sendCommand(2, C2_DEVICE_ID);
			setStatus("C2_DEVICE_ID", response);
			if (response.Result == ResponseCode.COMMAND_OK)
			{
				byte extraID = 0;
				byte deviceID = response.Raw[0];
				DeviceID.Text = response.Raw[0].ToString("X2");
				Revision.Text = response.Raw[1].ToString("X2");
				response = sendCommand(2, C2_UNIQUE_DEVICE_ID);
				setStatus("C2_UNIQUE_DEVICE_ID", response);

				if (response.Result == ResponseCode.COMMAND_OK)
				{
					UniqueID.Text = string.Format("{0:X2}.{1:X2}", response.Raw[1], response.Raw[0]);
					extraID = response.Raw[1];
				}
				cbDevices.SelectedIndex = -1;
				if (cbDevices.Items.Count > 0)
				{
					foreach (C2Device device in cbDevices.Items)
						if (device.ID == deviceID && (extraID == 0 || device.ExtraID == extraID))
						{
							cbDevices.SelectedItem = device;
							StartAddr.Text = addressToText(0);
							EndAddr.Text = addressToText(device.Bottom - 1);
							return true;
						}
				}
			}
			return false;
		}
		#endregion

		#region setStatus(string command, Response response) 
		private bool setStatus(string command, Response response)
		{
			StringBuilder sb = new StringBuilder(command);
			if (response.Result == ResponseCode.COMMAND_OK)
				sb.Append(": OK");
			else
				sb.AppendFormat(": {0} ({1:X2})", response.Result, (byte)response.Result);
			status.Text = sb.ToString();
			return (response.Result == ResponseCode.COMMAND_OK);
		}
		#endregion

		#region btnDeviceErase_Click(...) 
		private void btnDeviceErase_Click(object sender, EventArgs e)
		{
			if (MessageBox.Show("Do you want Erase Device ?", "Attention", MessageBoxButtons.OKCancel, MessageBoxIcon.Warning, MessageBoxDefaultButton.Button2) == DialogResult.OK)
			{
				Response response = sendCommand(0, C2_ERASE_FLASH_03);
				if (C2_Disconnect_Target() && C2_Connect_Target())
					setStatus("C2_ERASE_FLASH(03)", response);
			}
		}
		#endregion

		#region btnDeviceErase04_Click(...) 
		private void btnDeviceErase04_Click(object sender, EventArgs e)
		{
			if (MessageBox.Show("Do you want Erase Device ?", "Attention", MessageBoxButtons.OKCancel, MessageBoxIcon.Warning, MessageBoxDefaultButton.Button2) == DialogResult.OK)
			{
				Response response = sendCommand(0, C2_ERASE_FLASH_04);
				if (C2_Disconnect_Target() && C2_Connect_Target())
					setStatus("C2_ERASE_FLASH(04)", response);
			}
		}
		#endregion

		#region btnGo_Click(...) 
		private void btnGo_Click(object sender, EventArgs e)
		{
			setStatus("C2_TARGET_GO", sendCommand(0, C2_TARGET_GO));
		}
		#endregion

		#region btnHalt_Click(...) 
		private void btnHalt_Click(object sender, EventArgs e)
		{
			setStatus("C2_TARGET_HALT", sendCommand(0, C2_TARGET_HALT));
		}
		#endregion

		#region btnPageErase_Click(...) 
		private void btnPageErase_Click(object sender, EventArgs e)
		{
			int startAddr = 0, endAddr = 0;

			if (CurrentC2Device == null)
			{
				status.Text = "Select device from list";
				cbDevices.Focus();
				return;
			}

			if (validInt(StartAddr.Text, out startAddr) && validInt(EndAddr.Text, out endAddr))
			{
				startAddr &= ~0x1FF;
				endAddr = (endAddr + CurrentC2Device.FlashSectorSize - 1) & ~(CurrentC2Device.FlashSectorSize - 1);

				if (startAddr > endAddr)
				{
					MessageBox.Show("Bad range");
					return;
				}
				if (MessageBox.Show(
					string.Format("Do you want Erase Page {0}:{1} ?", addressToText(startAddr), addressToText(endAddr)),
					"Attention", MessageBoxButtons.OKCancel, MessageBoxIcon.Warning, MessageBoxDefaultButton.Button2) != DialogResult.OK)
					return;

				int pageCount = (endAddr - startAddr) / CurrentC2Device.FlashSectorSize + 1;

				float delta = ((float)(progress.Maximum - progress.Minimum)) / (float)pageCount;
				progress.Value = progress.Minimum;
				int erasedPages = 0;
				Response response = null;
				while (startAddr < endAddr)
				{
					response = sendCommand(0, C2_ERASE_PAGE, (byte)((startAddr >> 9) & 0xFF));
					setStatus("C2_ERASE_PAGE", response);
					if (response.Result != ResponseCode.COMMAND_OK)
						break;
					startAddr += CurrentC2Device.FlashSectorSize;
					erasedPages++;
					progress.Value = (int)(delta * ((float)(erasedPages)));
				}
				progress.Value = progress.Minimum;
				if (response != null && response.Result == ResponseCode.COMMAND_OK)
				{
					status.Text = "Erase pages complete.";
				}
			}
		}
		#endregion

		#region validInt(string sv, out int v) 
		private bool validInt(string sv, out int v)
		{
			bool result = false;
			v = 0;
			sv = sv.Trim();
			if (string.IsNullOrEmpty(sv))
			{
				status.Text = "Value can't be empty";
			}
			else
			{
				if (sv.StartsWith("0x") || sv.StartsWith("x"))
					result = int.TryParse(sv.Substring(sv.IndexOf("x") + 1), NumberStyles.HexNumber, null, out v);
				else
					result = int.TryParse(sv, out v);
				if(!result)
					status.Text = string.Format("Can't parse value {0}.", sv);
			}
			return result;
		}
		#endregion

		#region btnReadFlash_Click(object sender, EventArgs e) 
		private void btnReadFlash_Click(object sender, EventArgs e)
		{
			int startAddress, endAddress;
			if (!validInt(StartAddr.Text, out startAddress) || !validInt(EndAddr.Text, out endAddress))
				return;

			string file = saveFileDialog.FileName;
			if (!string.IsNullOrEmpty(file))
			{
				saveFileDialog.InitialDirectory = Path.GetDirectoryName(file);
				saveFileDialog.FileName = Path.GetFileName(file);
			}

			if (saveFileDialog.ShowDialog() == DialogResult.OK)
			{
				try
				{
					using (Stream s = File.Open(saveFileDialog.FileName,
						File.Exists(saveFileDialog.FileName) ? FileMode.Truncate : FileMode.Create,
						FileAccess.Write))
					{

						int byteCount = endAddress - startAddress + 1;
						float delta = ((float)(progress.Maximum - progress.Minimum)) / (float)byteCount;
						int readedBytes = 0;
						Response response = null;
						int addressAt = startAddress;
						int totalBytes = byteCount;
						while (byteCount > 0)
						{
							int count = (byteCount > 128) ? 128 : byteCount;

							response = sendCommand(count,
								C2_READ_FLASH,
								(byte)(startAddress & 0xFF),
								(byte)((startAddress >> 8) & 0xFF),
								(byte)count
								);
							if (response.Result != ResponseCode.COMMAND_OK)
								break;

							s.Write(response.Raw, 0, count);

							startAddress += count;
							byteCount -= count;
							readedBytes += count;
							if (readedBytes % 512 == 0)
							{
								progress.Value = (int)(delta * ((float)(readedBytes)));
								status.Text = string.Format("Reading {0} bytes from {1} ({2}%) ...", addressToText(count), addressToText(startAddress), (int)(100 * readedBytes / totalBytes));
								Application.DoEvents();
							}
						}
						s.Close();
						progress.Value = 0;
						if (response != null)
						{
							if (response.Result == ResponseCode.COMMAND_OK)
								status.Text = string.Format("Reading {0} bytes at {1} complete.", addressToText(totalBytes), addressToText(addressAt));
							else
								setStatus("C2_READ_FLASH", response);
						}
					}
				}
				catch (Exception ex)
				{
					MessageBox.Show(ex.Message);
				}
			}
		}
		#endregion

		#region Write Flash 
		private void btnWriteFlash_Click(object sender, EventArgs e)
		{
			if (FileName.Text.Trim().Length > 0)
			{
				writeFileToFlash(true);
			}
			else if (openFileDialog.ShowDialog() == DialogResult.OK)
			{
				FileName.Text = openFileDialog.FileName;
				writeFileToFlash(true);
			}
		}

		private void btnWriteFlashPartial_Click(object sender, EventArgs e)
		{
			writeFileToFlash(false);
		}

		private void writeFileToFlash(bool setAddresses)
		{
			if (!selectC2Device())
				return;

			if (FileName.Text.Length == 0)
			{
				if (openFileDialog.ShowDialog() == DialogResult.OK)
				{
					FileName.Text = openFileDialog.FileName;
					setAddresses = true;
				}
				else
					return;
			}

			try
			{
				int flashSize = CurrentC2Device.Bottom;

				byte[] flash_buffer = new byte[flashSize];
				for (int idx = 0; idx < flash_buffer.Length; idx++)
					flash_buffer[idx] = 0xFF;

				List<HexRange> ranges = new List<HexRange>();
				bool enableFlash = false;

				int startAddress = -1, endAddress = -1;
				if (!validInt(StartAddr.Text, out startAddress) || !validInt(EndAddr.Text, out endAddress))
					return;

				if (Path.GetExtension(FileName.Text).Equals(".hex", StringComparison.InvariantCultureIgnoreCase))
				{
					int minAddress = int.MaxValue, maxAddress = int.MinValue;
					bool fail = false;

					#region Load HEX file 
					using (TextReader s = new StreamReader(FileName.Text))
					{
						string line;
						int lineNumber = 0;
						int count = 0;
						int ext_address = 0, seg_address = 0, address = 0;
						byte command = 0;
						byte checksum = 0;
						int pos;
						byte data;

						while ((line = s.ReadLine()) != null)
						{
							++lineNumber;
							line = line.Trim();
							if (line.Length == 0 || !line.StartsWith(":"))
								continue;

							if (line.Length < 11)
							{
								fail = true;
							}
							else
							{
								fail |= !int.TryParse(line.Substring(1, 2), NumberStyles.HexNumber, CultureInfo.InvariantCulture, out count);
								fail |= !int.TryParse(line.Substring(3, 4), NumberStyles.HexNumber, CultureInfo.InvariantCulture, out address);
								fail |= !byte.TryParse(line.Substring(7, 2), NumberStyles.HexNumber, CultureInfo.InvariantCulture, out command);
								fail |= !byte.TryParse(line.Substring(line.Length - 2, 2), NumberStyles.HexNumber, CultureInfo.InvariantCulture, out checksum);
							}

							if (fail)
							{
								MessageBox.Show(string.Format("Can't parse line {0}", lineNumber));
								break;
							}

							int calculatedCheckSum = count + ((address >> 8) & 0xFF) + (address & 0xFF) + command;
							pos = 9;

							if (command == 2 || command == 4)
							{
								if (line.Length != 15)
									fail = true;
								else if(command == 2)
									fail |= !int.TryParse(line.Substring(pos, 4), NumberStyles.HexNumber, null, out seg_address);
								else
									fail |= !int.TryParse(line.Substring(pos, 4), NumberStyles.HexNumber, null, out ext_address);

								if (fail)
								{
									if(command == 2)
										MessageBox.Show(string.Format("Bad extended segment address record at line {0}.", lineNumber));
									else
										MessageBox.Show(string.Format("Bad extended linear address record at line {0}.", lineNumber));
								}
							}
							else if (command == 0)
							{
								if (count > 0)
								{
									int next = address + count;
									bool add = true;
									foreach (HexRange range in ranges)
									{
										if (range.Next == address)
										{
											range.Count += count;
											add = false;
											break;
										}
										else if (next == range.Address)
										{
											range.Address = address;
											range.Count += count;
											add = false;
											break;
										}
										fail = range.IsInner(address) || range.IsInner(next);
										if (fail)
											break;
									}

									if (fail)
									{
										MessageBox.Show(string.Format("Address range overlapped at line {0}.", lineNumber));
										break;
									}
									if (add)
										ranges.Add(new HexRange(address, count));
								}

								for (; count > 0; --count)
								{
									if (address >= flashSize)
									{
										MessageBox.Show(string.Format("Address {0} outside flash size at line {1}.", addressToText(address), lineNumber));
										fail = true;
										break;
									}

									if (CurrentC2Device.LockType == "FLT_SINGLE" && address == CurrentC2Device.SingleLock)
									{
										if (MessageBox.Show(string.Format("File write to LOCK byte ({0:X4}).\nAre you sure ?", address), "Attention", MessageBoxButtons.OKCancel, MessageBoxIcon.Warning, MessageBoxDefaultButton.Button1, MessageBoxOptions.DefaultDesktopOnly) != DialogResult.OK)
										{
											fail = true;
											break;
										}
									}

									if (address < minAddress)
										minAddress = address;
									if (address > maxAddress)
										maxAddress = address;

									fail |= !byte.TryParse(line.Substring(pos, 2), NumberStyles.HexNumber, CultureInfo.InvariantCulture, out data);
									pos += 2;
									if (fail)
									{
										MessageBox.Show(string.Format("Bad data \"{0}\" at line {1}.", line.Substring(pos, 2), lineNumber));
										break;
									}
									flash_buffer[address++] = data;
									calculatedCheckSum += (int)data;
								}
							}

							if (fail)
								break;

							fail |= (((calculatedCheckSum + checksum) & 0xFF) != 0);
							if (fail)
							{
								MessageBox.Show(string.Format("Bad checksum {0:X2}:{1:X2} at line {2}.", checksum, calculatedCheckSum, lineNumber));
								break;
							}

							// EOF record
							if (command == 1)
								break;
						}
						s.Close();
					}
					#endregion

					#region Collapse HEX ranges and check overlap 
					if (!fail)
					{
						if (ranges.Count == 0)
						{
							MessageBox.Show("No data to write in file");
							fail = true;
						}
						else
						{
							for (int i = 0; i < ranges.Count; i++)
							{
								HexRange rangeI = ranges[i];
								for (int j = 0; j < ranges.Count; j++)
								{
									if (i == j)
										continue;
									HexRange rangeJ = ranges[j];
									if (rangeI.Next == rangeJ.Address)
									{
										rangeI.Count += rangeJ.Count;
										ranges.RemoveAt(j);
										i = -1;
										break;
									}
									if (rangeJ.Next == rangeI.Address)
									{
										rangeJ.Count += rangeI.Count;
										ranges.RemoveAt(i);
										i = -1;
										break;
									}
									fail = rangeI.IsInner(rangeJ.Address) || rangeI.IsInner(rangeJ.Next);
									if (fail)
									{
										MessageBox.Show(string.Format("Addresses overlapped {0}:{1} and {2}:{3}",
											addressToText(rangeI.Address),
											addressToText(rangeI.Next),
											addressToText(rangeJ.Address),
											addressToText(rangeJ.Next)
											));
										break;
									}
								}
								if (fail)
									break;
							}
						}
					}
					#endregion

					#region Check Addresses and ranges 
					if (!fail)
					{
						if (setAddresses)
						{
							if (ranges.Count > 0)
							{
								startAddress = minAddress;
								endAddress = maxAddress;
								StartAddr.Text = addressToText(minAddress);
								EndAddr.Text = addressToText(maxAddress);
							}
						}
						else if (endAddress > maxAddress || startAddress < minAddress)
						{
							MessageBox.Show("File data less than bytes to write");
							fail = true;
						}
						else
						{
							HexRange range = new HexRange(startAddress, endAddress - startAddress + 1);
							for (int i = 0; i < ranges.Count; ++i)
							{
								HexRange rangeS = ranges[i];
								if (!range.IsOverlapped(rangeS))
								{
									ranges.RemoveAt(i);
									--i;
								}
							}
						}
					}
					if (!fail)
					{
						if (ranges.Count == 0)
						{
							MessageBox.Show("No data to write in file");
							fail = true;
						}
						else
							enableFlash = true;
					}
					#endregion
				}
				else if (Path.GetExtension(FileName.Text).Equals(".bin", StringComparison.InvariantCultureIgnoreCase))
				{
					#region Load BIN file 
					using (Stream s = File.OpenRead(FileName.Text))
					{
						enableFlash = true;
						int fileLength = (int)s.Length;
						if (setAddresses)
						{
							endAddress = startAddress + fileLength - 1;
							if (startAddress >= flashSize)
							{
								MessageBox.Show("Invalid start address");
									enableFlash = false;
							}
							else if (endAddress >= flashSize)
							{
								if (MessageBox.Show("File data more than available flash.\nWrite partial content ?", "Attension", MessageBoxButtons.OKCancel, MessageBoxIcon.Warning, MessageBoxDefaultButton.Button1, MessageBoxOptions.DefaultDesktopOnly) != DialogResult.OK)
									enableFlash = false;
								else
								{
									endAddress = flashSize - startAddress - 1;
									fileLength = flashSize - startAddress;
								}

							}
							else
								EndAddr.Text = addressToText(endAddress);
						}
						else if ((endAddress - startAddress + 1) > fileLength)
						{
							MessageBox.Show("File data less than bytes to write");
							enableFlash = false;
						}
						if (enableFlash)
							s.Read(flash_buffer, startAddress, fileLength);
						s.Close();
					}
					#endregion
				}
				else
				{
					MessageBox.Show("Insupported file type");
				}

				if (enableFlash)
				{
					if (startAddress < 0 ||
						endAddress < 0 ||
						startAddress >= flashSize ||
						endAddress >= flashSize
						)
						MessageBox.Show("File data more than available flash.");
					else
					{
						int byteCount = endAddress - startAddress + 1;
						if (MessageBox.Show(
							string.Format(
								"Continue write {0} bytes\nfrom {1} to {2}",
								addressToText(byteCount),
								addressToText(startAddress),
								addressToText(endAddress)),
								"Attention", MessageBoxButtons.OKCancel, MessageBoxIcon.Question, MessageBoxDefaultButton.Button2) == DialogResult.OK)
						{
							float delta = ((float)(progress.Maximum - progress.Minimum)) / (float)byteCount;
							int writtenBytes = 0;
							Response response = null;
							int addressAt = startAddress;
							int totalBytes = byteCount;
							ranges.Clear();
							while (byteCount > 0)
							{
								int count = (byteCount > 128) ? 128 : byteCount;

								#region Auto erase page
								if (cbAutoErase.Checked)
								{
									// Check for page erase
									bool erase = true;
									foreach (HexRange range in ranges)
									{
										if (range.IsInner(startAddress))
										{
											erase = false;
											break;
										}
									}
									if (erase)
									{
										response = sendCommand(0, C2_ERASE_PAGE, (byte)((startAddress >> 9) & 0xFF));
										if (response.Result != ResponseCode.COMMAND_OK)
											break;
										ranges.Add(new HexRange(startAddress & ~(CurrentC2Device.FlashSectorSize - 1), CurrentC2Device.FlashSectorSize));
									}

									// Also check end address to erase
									erase = true;
									endAddress = startAddress + count - 1;
									foreach (HexRange range in ranges)
									{
										if (range.IsInner(endAddress))
										{
											erase = false;
											break;
										}
									}
									if (erase)
									{
										response = sendCommand(0, C2_ERASE_PAGE, (byte)((endAddress >> 9) & 0xFF));
										if (response.Result != ResponseCode.COMMAND_OK)
											break;
										ranges.Add(new HexRange(endAddress & ~(CurrentC2Device.FlashSectorSize - 1), CurrentC2Device.FlashSectorSize));
									}
								}
								#endregion

								response = sendCommand(0, flash_buffer, startAddress, count, C2_WRITE_FLASH, (byte)(startAddress & 0xFF), (byte)((startAddress >> 8) & 0xFF), (byte)count);
								if (response.Result != ResponseCode.COMMAND_OK)
									break;

								startAddress += count;
								byteCount -= count;
								writtenBytes += count;
								if (writtenBytes % 512 == 0)
								{
									progress.Value = (int)(delta * ((float)(writtenBytes)));
									status.Text = string.Format("Writing {0} bytes at {1} ({2}%)...", addressToText(count), addressToText(startAddress), (int)(100 * writtenBytes / totalBytes));
									Application.DoEvents();
								}
							}
							progress.Value = progress.Minimum;

							if (C2_Disconnect_Target() && C2_Connect_Target() && C2_Device_Info() && response != null)
							{
								if(response.Result != ResponseCode.COMMAND_OK)
									setStatus("C2_WRITE_FLASH", response);
								else
									status.Text = string.Format("Writing {0} bytes at {1} complete.", addressToText(totalBytes), addressToText(addressAt));
							}
						}
					}
				}
			}
			catch (Exception ex)
			{
				MessageBox.Show(ex.Message);
			}
		}
		#endregion

		#region btnAddressRead_Click(...)
		private void btnAddressRead_Click(object sender, EventArgs e)
		{
			Response response = sendCommand(1, C2_ADDRESSREAD);
			if (setStatus("C2_ADDRESSREAD", response))
				AddressRead.Text = response.Raw[0].ToString("X2");
			else
				AddressRead.Text = "";
		}
		#endregion

		#region btnDataRead_Click(...) 
		private void btnDataRead_Click(object sender, EventArgs e)
		{
			Response response = sendCommand(1, C2_DATAREAD);
			if (setStatus("C2_DATAREAD", response))
				DataRead.Text = response.Raw[0].ToString("X2");
			else
				DataRead.Text = "";
		}
		#endregion

		#region addressToText(int address) 
		private string addressToText(int address)
		{
			return "0x" + address.ToString("X4");
		}
		#endregion

		#region selectC2Device() 
		private bool selectC2Device()
		{
			if (CurrentC2Device == null)
			{
				status.Text = "Select C2 Device from list";
				cbDevices.Focus();
				return false;
			}
			return true;
		}
		#endregion

		#region btnVerify_Click(object sender, EventArgs e) 
		private void btnVerify_Click(object sender, EventArgs e)
		{
			MessageBox.Show("Not supported");
		}
		#endregion

		#region cbDevices_SelectedIndexChanged(object sender, EventArgs e) 
		private void cbDevices_SelectedIndexChanged(object sender, EventArgs e)
		{
			if (CurrentC2Device != null)
			{
				StartAddr.Text = "0x0000";
				EndAddr.Text = addressToText(CurrentC2Device.Bottom - 1);
				Response response = sendCommand(0, SET_FPDAT_ADDRESS, CurrentC2Device.FPREG);
				setStatus(string.Format("SET_FPDAT_ADDRESS:{0:X2}", CurrentC2Device.FPREG), response);
				if (response.Result == ResponseCode.COMMAND_OK)
				{
				}
				response = sendCommand(1, GET_FPDAT_ADDRESS);
				if (response.Result == ResponseCode.COMMAND_OK)
				{
					if (response.Raw[0] != CurrentC2Device.FPREG)
						MessageBox.Show("GET_FPDAT_ADDRESS failure");
				}
				else
					setStatus("GET_FPDAT_ADDRESS", response);
			}
		}
		#endregion

		private void btnAddressWrite_Click(object sender, EventArgs e)
		{
			int data = 0;
			if (validInt(AddressWrite.Text, out data))
			{
				setStatus("C2_ADDRESS_WRITE", sendCommand(0, C2_ADDRESS_WRITE, (byte)data));
			}
			else
			{
				AddressWrite.Focus();
				status.Text = "Bad data.";
			}
		}

		private void btnDataWrite_Click(object sender, EventArgs e)
		{
			int data = 0;
			if (validInt(DataWrite.Text, out data))
			{
				setStatus("C2_DATA_WRITE", sendCommand(0, C2_DATA_WRITE, (byte)data));
			}
			else
			{
				DataWrite.Focus();
				status.Text = "Bad data.";
			}
		}
	}

	#region Class Response 
	public class Response
	{
		public byte[] Raw;
		public AutoResetEvent WaitEvent;
		public int Length;
		public ResponseCode Result;
		public bool Complete;

		public Response(int length)
		{
			Length = length;
			Raw = null;
			Result = ResponseCode.COMMAND_NO_RESPONSE;
			WaitEvent = new AutoResetEvent(false);
			Complete = false;
		}
	}
	#endregion

	#region Class C2Device 
	public class C2Device
	{
		public string Name;
		public byte ID;
		public byte ExtraID;
		public int Version;
		public string StringObserved;
		public int FlashSize;
		public int FlashSectorSize;
		public int XramSize;
		public bool ExternalBus;
		public bool Tested;
		public string LockType;
		public int Readlock;
		public int WriteLock;
		public int SingleLock;
		public int Bottom;
		public int Top;
		public bool Present;
		public int Start;
		public int Length;
		public int SectorSize;
		public bool PagedSFR;
		public int SFR_Page;
		public bool USBFIFO;
		public int USBFIFOSize;
		public string DebugInterface;
		public int Cache;
		public string BP0L;
		public string BP0H;
		public string BP1L;
		public string BP1H;
		public string BP2L;
		public string BP2H;
		public string BP3L;
		public string BP3H;
		public string Comments;
		public byte FPREG;

		public override string ToString()
		{
			return Name;
		}
	}
	#endregion

	#region HexRange 
	public class HexRange
	{
		private int address = 0;
		private int count = 0;
		private int next = 0;

		public int Address
		{
			get { return address; }
			set
			{
				address = value;
				next = address + count;
			}
		}
		public int Count
		{
			get { return count; }
			set
			{
				count = value;
				next = address + count;
			}
		}
		public int Next
		{
			get { return next; }
		}

		public bool IsInner(int point)
		{
			return (point >= address && point < next);
		}

		public HexRange(int address, int count)
		{
			Address = address;
			Count = count;
		}

		public override string ToString()
		{
			return address.ToString("X4") + ":" + next.ToString("X4");
		}

		public bool IsOverlapped(HexRange range)
		{
			if (range.Address >= next)
				return false;
			if (range.Next <= address)
				return false;
			if (this.IsInner(range.Address) || this.IsInner(range.Next - 1))
				return true;
			if (range.IsInner(address) || range.IsInner(next - 1))
				return true;
			return false;
		}
	}
	#endregion
}
