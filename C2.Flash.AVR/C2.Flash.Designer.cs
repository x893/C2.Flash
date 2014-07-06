namespace C2.Flash
{
	partial class frmMain
	{
		/// <summary>
		/// Required designer variable.
		/// </summary>
		private System.ComponentModel.IContainer components = null;

		/// <summary>
		/// Clean up any resources being used.
		/// </summary>
		/// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
		protected override void Dispose(bool disposing)
		{
			if (disposing && (components != null))
			{
				components.Dispose();
			}
			base.Dispose(disposing);
		}

		#region Windows Form Designer generated code

		/// <summary>
		/// Required method for Designer support - do not modify
		/// the contents of this method with the code editor.
		/// </summary>
		private void InitializeComponent()
		{
			this.cbPorts = new System.Windows.Forms.ComboBox();
			this.cbAutoConnect = new System.Windows.Forms.CheckBox();
			this.btnStartStop = new System.Windows.Forms.Button();
			this.cbDTREnable = new System.Windows.Forms.CheckBox();
			this.btnC2Target = new System.Windows.Forms.Button();
			this.groupC2 = new System.Windows.Forms.GroupBox();
			this.cbAutoErase = new System.Windows.Forms.CheckBox();
			this.btnVerify = new System.Windows.Forms.Button();
			this.btnWriteFlashPartial = new System.Windows.Forms.Button();
			this.label8 = new System.Windows.Forms.Label();
			this.label7 = new System.Windows.Forms.Label();
			this.btnDeviceErase04 = new System.Windows.Forms.Button();
			this.DataRead = new System.Windows.Forms.TextBox();
			this.btnDataRead = new System.Windows.Forms.Button();
			this.AddressRead = new System.Windows.Forms.TextBox();
			this.btnAddressRead = new System.Windows.Forms.Button();
			this.label6 = new System.Windows.Forms.Label();
			this.DataWrite = new System.Windows.Forms.TextBox();
			this.btnDataWrite = new System.Windows.Forms.Button();
			this.btnAddressWrite = new System.Windows.Forms.Button();
			this.label5 = new System.Windows.Forms.Label();
			this.AddressWrite = new System.Windows.Forms.TextBox();
			this.btnDeviceErase = new System.Windows.Forms.Button();
			this.EndAddr = new System.Windows.Forms.TextBox();
			this.StartAddr = new System.Windows.Forms.TextBox();
			this.btnPageErase = new System.Windows.Forms.Button();
			this.FileName = new System.Windows.Forms.TextBox();
			this.btnHalt = new System.Windows.Forms.Button();
			this.btnGo = new System.Windows.Forms.Button();
			this.btnReadSFR = new System.Windows.Forms.Button();
			this.btnReadRAM = new System.Windows.Forms.Button();
			this.btnReadXRAM = new System.Windows.Forms.Button();
			this.btnReadFlash = new System.Windows.Forms.Button();
			this.btnWriteFlash = new System.Windows.Forms.Button();
			this.label4 = new System.Windows.Forms.Label();
			this.cbDevices = new System.Windows.Forms.ComboBox();
			this.label3 = new System.Windows.Forms.Label();
			this.UniqueID = new System.Windows.Forms.TextBox();
			this.label2 = new System.Windows.Forms.Label();
			this.Revision = new System.Windows.Forms.TextBox();
			this.label1 = new System.Windows.Forms.Label();
			this.DeviceID = new System.Windows.Forms.TextBox();
			this.statusStrip = new System.Windows.Forms.StatusStrip();
			this.status = new System.Windows.Forms.ToolStripStatusLabel();
			this.progress = new System.Windows.Forms.ToolStripProgressBar();
			this.openFileDialog = new System.Windows.Forms.OpenFileDialog();
			this.saveFileDialog = new System.Windows.Forms.SaveFileDialog();
			this.groupC2.SuspendLayout();
			this.statusStrip.SuspendLayout();
			this.SuspendLayout();
			// 
			// cbPorts
			// 
			this.cbPorts.FormattingEnabled = true;
			this.cbPorts.Location = new System.Drawing.Point(4, 12);
			this.cbPorts.Name = "cbPorts";
			this.cbPorts.Size = new System.Drawing.Size(111, 21);
			this.cbPorts.TabIndex = 0;
			// 
			// cbAutoConnect
			// 
			this.cbAutoConnect.AutoSize = true;
			this.cbAutoConnect.Location = new System.Drawing.Point(12, 39);
			this.cbAutoConnect.Name = "cbAutoConnect";
			this.cbAutoConnect.Size = new System.Drawing.Size(88, 17);
			this.cbAutoConnect.TabIndex = 2;
			this.cbAutoConnect.Text = "AutoConnect";
			this.cbAutoConnect.UseVisualStyleBackColor = true;
			// 
			// btnStartStop
			// 
			this.btnStartStop.Location = new System.Drawing.Point(125, 10);
			this.btnStartStop.Name = "btnStartStop";
			this.btnStartStop.Size = new System.Drawing.Size(100, 23);
			this.btnStartStop.TabIndex = 1;
			this.btnStartStop.Text = "Connect";
			this.btnStartStop.UseVisualStyleBackColor = true;
			this.btnStartStop.Click += new System.EventHandler(this.btnStartStop_Click);
			// 
			// cbDTREnable
			// 
			this.cbDTREnable.AutoSize = true;
			this.cbDTREnable.Location = new System.Drawing.Point(12, 61);
			this.cbDTREnable.Name = "cbDTREnable";
			this.cbDTREnable.Size = new System.Drawing.Size(180, 17);
			this.cbDTREnable.TabIndex = 3;
			this.cbDTREnable.Text = "DTR Enable (auto reset Arduino)";
			this.cbDTREnable.UseVisualStyleBackColor = true;
			this.cbDTREnable.CheckedChanged += new System.EventHandler(this.cbDTREnable_CheckedChanged);
			// 
			// btnC2Target
			// 
			this.btnC2Target.Location = new System.Drawing.Point(113, 57);
			this.btnC2Target.Name = "btnC2Target";
			this.btnC2Target.Size = new System.Drawing.Size(100, 23);
			this.btnC2Target.TabIndex = 4;
			this.btnC2Target.Text = "C2 Check";
			this.btnC2Target.UseVisualStyleBackColor = true;
			this.btnC2Target.Click += new System.EventHandler(this.btnC2Target_Click);
			// 
			// groupC2
			// 
			this.groupC2.Controls.Add(this.cbAutoErase);
			this.groupC2.Controls.Add(this.btnVerify);
			this.groupC2.Controls.Add(this.btnWriteFlashPartial);
			this.groupC2.Controls.Add(this.label8);
			this.groupC2.Controls.Add(this.label7);
			this.groupC2.Controls.Add(this.btnDeviceErase04);
			this.groupC2.Controls.Add(this.DataRead);
			this.groupC2.Controls.Add(this.btnDataRead);
			this.groupC2.Controls.Add(this.AddressRead);
			this.groupC2.Controls.Add(this.btnAddressRead);
			this.groupC2.Controls.Add(this.label6);
			this.groupC2.Controls.Add(this.DataWrite);
			this.groupC2.Controls.Add(this.btnDataWrite);
			this.groupC2.Controls.Add(this.btnAddressWrite);
			this.groupC2.Controls.Add(this.label5);
			this.groupC2.Controls.Add(this.AddressWrite);
			this.groupC2.Controls.Add(this.btnDeviceErase);
			this.groupC2.Controls.Add(this.EndAddr);
			this.groupC2.Controls.Add(this.StartAddr);
			this.groupC2.Controls.Add(this.btnPageErase);
			this.groupC2.Controls.Add(this.FileName);
			this.groupC2.Controls.Add(this.btnHalt);
			this.groupC2.Controls.Add(this.btnGo);
			this.groupC2.Controls.Add(this.btnReadSFR);
			this.groupC2.Controls.Add(this.btnReadRAM);
			this.groupC2.Controls.Add(this.btnReadXRAM);
			this.groupC2.Controls.Add(this.btnReadFlash);
			this.groupC2.Controls.Add(this.btnWriteFlash);
			this.groupC2.Controls.Add(this.label4);
			this.groupC2.Controls.Add(this.cbDevices);
			this.groupC2.Controls.Add(this.label3);
			this.groupC2.Controls.Add(this.UniqueID);
			this.groupC2.Controls.Add(this.label2);
			this.groupC2.Controls.Add(this.Revision);
			this.groupC2.Controls.Add(this.label1);
			this.groupC2.Controls.Add(this.DeviceID);
			this.groupC2.Controls.Add(this.btnC2Target);
			this.groupC2.Enabled = false;
			this.groupC2.ForeColor = System.Drawing.SystemColors.ControlText;
			this.groupC2.Location = new System.Drawing.Point(12, 96);
			this.groupC2.Name = "groupC2";
			this.groupC2.Size = new System.Drawing.Size(551, 288);
			this.groupC2.TabIndex = 5;
			this.groupC2.TabStop = false;
			this.groupC2.Text = "C2 TARGET";
			// 
			// cbAutoErase
			// 
			this.cbAutoErase.AutoSize = true;
			this.cbAutoErase.Checked = true;
			this.cbAutoErase.CheckState = System.Windows.Forms.CheckState.Checked;
			this.cbAutoErase.Location = new System.Drawing.Point(332, 34);
			this.cbAutoErase.Name = "cbAutoErase";
			this.cbAutoErase.Size = new System.Drawing.Size(111, 17);
			this.cbAutoErase.TabIndex = 40;
			this.cbAutoErase.Text = "Auto Erase Pages";
			this.cbAutoErase.UseVisualStyleBackColor = true;
			// 
			// btnVerify
			// 
			this.btnVerify.Location = new System.Drawing.Point(229, 57);
			this.btnVerify.Name = "btnVerify";
			this.btnVerify.Size = new System.Drawing.Size(100, 23);
			this.btnVerify.TabIndex = 39;
			this.btnVerify.Text = "Verify Flash";
			this.btnVerify.UseVisualStyleBackColor = true;
			this.btnVerify.Click += new System.EventHandler(this.btnVerify_Click);
			// 
			// btnWriteFlashPartial
			// 
			this.btnWriteFlashPartial.Location = new System.Drawing.Point(332, 109);
			this.btnWriteFlashPartial.Name = "btnWriteFlashPartial";
			this.btnWriteFlashPartial.Size = new System.Drawing.Size(100, 23);
			this.btnWriteFlashPartial.TabIndex = 38;
			this.btnWriteFlashPartial.Text = "Write Flash ...";
			this.btnWriteFlashPartial.UseVisualStyleBackColor = true;
			this.btnWriteFlashPartial.Click += new System.EventHandler(this.btnWriteFlashPartial_Click);
			// 
			// label8
			// 
			this.label8.AutoSize = true;
			this.label8.Location = new System.Drawing.Point(175, 114);
			this.label8.Name = "label8";
			this.label8.Size = new System.Drawing.Size(45, 13);
			this.label8.TabIndex = 37;
			this.label8.Text = "Address";
			this.label8.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
			// 
			// label7
			// 
			this.label7.AutoSize = true;
			this.label7.Location = new System.Drawing.Point(197, 88);
			this.label7.Name = "label7";
			this.label7.Size = new System.Drawing.Size(23, 13);
			this.label7.TabIndex = 36;
			this.label7.Text = "File";
			this.label7.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
			// 
			// btnDeviceErase04
			// 
			this.btnDeviceErase04.Location = new System.Drawing.Point(332, 181);
			this.btnDeviceErase04.Name = "btnDeviceErase04";
			this.btnDeviceErase04.Size = new System.Drawing.Size(100, 23);
			this.btnDeviceErase04.TabIndex = 35;
			this.btnDeviceErase04.Text = "Device Erase (04)";
			this.btnDeviceErase04.UseVisualStyleBackColor = true;
			this.btnDeviceErase04.Click += new System.EventHandler(this.btnDeviceErase04_Click);
			// 
			// DataRead
			// 
			this.DataRead.Enabled = false;
			this.DataRead.Location = new System.Drawing.Point(67, 261);
			this.DataRead.Name = "DataRead";
			this.DataRead.Size = new System.Drawing.Size(36, 20);
			this.DataRead.TabIndex = 34;
			this.DataRead.TextAlign = System.Windows.Forms.HorizontalAlignment.Right;
			// 
			// btnDataRead
			// 
			this.btnDataRead.Location = new System.Drawing.Point(113, 259);
			this.btnDataRead.Name = "btnDataRead";
			this.btnDataRead.Size = new System.Drawing.Size(100, 23);
			this.btnDataRead.TabIndex = 33;
			this.btnDataRead.Text = "Data Read";
			this.btnDataRead.UseVisualStyleBackColor = true;
			this.btnDataRead.Click += new System.EventHandler(this.btnDataRead_Click);
			// 
			// AddressRead
			// 
			this.AddressRead.Enabled = false;
			this.AddressRead.Location = new System.Drawing.Point(67, 235);
			this.AddressRead.Name = "AddressRead";
			this.AddressRead.Size = new System.Drawing.Size(36, 20);
			this.AddressRead.TabIndex = 32;
			this.AddressRead.TextAlign = System.Windows.Forms.HorizontalAlignment.Right;
			// 
			// btnAddressRead
			// 
			this.btnAddressRead.Location = new System.Drawing.Point(113, 233);
			this.btnAddressRead.Name = "btnAddressRead";
			this.btnAddressRead.Size = new System.Drawing.Size(100, 23);
			this.btnAddressRead.TabIndex = 31;
			this.btnAddressRead.Text = "Address Read";
			this.btnAddressRead.UseVisualStyleBackColor = true;
			this.btnAddressRead.Click += new System.EventHandler(this.btnAddressRead_Click);
			// 
			// label6
			// 
			this.label6.AutoSize = true;
			this.label6.Location = new System.Drawing.Point(31, 212);
			this.label6.Name = "label6";
			this.label6.Size = new System.Drawing.Size(30, 13);
			this.label6.TabIndex = 30;
			this.label6.Text = "Data";
			this.label6.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
			// 
			// DataWrite
			// 
			this.DataWrite.Location = new System.Drawing.Point(67, 209);
			this.DataWrite.Name = "DataWrite";
			this.DataWrite.Size = new System.Drawing.Size(36, 20);
			this.DataWrite.TabIndex = 29;
			this.DataWrite.TextAlign = System.Windows.Forms.HorizontalAlignment.Right;
			// 
			// btnDataWrite
			// 
			this.btnDataWrite.Location = new System.Drawing.Point(113, 207);
			this.btnDataWrite.Name = "btnDataWrite";
			this.btnDataWrite.Size = new System.Drawing.Size(100, 23);
			this.btnDataWrite.TabIndex = 28;
			this.btnDataWrite.Text = "Data Write";
			this.btnDataWrite.UseVisualStyleBackColor = true;
			this.btnDataWrite.Click += new System.EventHandler(this.btnDataWrite_Click);
			// 
			// btnAddressWrite
			// 
			this.btnAddressWrite.Location = new System.Drawing.Point(113, 181);
			this.btnAddressWrite.Name = "btnAddressWrite";
			this.btnAddressWrite.Size = new System.Drawing.Size(100, 23);
			this.btnAddressWrite.TabIndex = 27;
			this.btnAddressWrite.Text = "Address Write";
			this.btnAddressWrite.UseVisualStyleBackColor = true;
			this.btnAddressWrite.Click += new System.EventHandler(this.btnAddressWrite_Click);
			// 
			// label5
			// 
			this.label5.AutoSize = true;
			this.label5.Location = new System.Drawing.Point(16, 186);
			this.label5.Name = "label5";
			this.label5.Size = new System.Drawing.Size(45, 13);
			this.label5.TabIndex = 26;
			this.label5.Text = "Address";
			this.label5.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
			// 
			// AddressWrite
			// 
			this.AddressWrite.Location = new System.Drawing.Point(67, 183);
			this.AddressWrite.Name = "AddressWrite";
			this.AddressWrite.Size = new System.Drawing.Size(36, 20);
			this.AddressWrite.TabIndex = 25;
			this.AddressWrite.TextAlign = System.Windows.Forms.HorizontalAlignment.Right;
			// 
			// btnDeviceErase
			// 
			this.btnDeviceErase.Location = new System.Drawing.Point(332, 155);
			this.btnDeviceErase.Name = "btnDeviceErase";
			this.btnDeviceErase.Size = new System.Drawing.Size(100, 23);
			this.btnDeviceErase.TabIndex = 24;
			this.btnDeviceErase.Text = "Device Erase (03)";
			this.btnDeviceErase.UseVisualStyleBackColor = true;
			this.btnDeviceErase.Click += new System.EventHandler(this.btnDeviceErase_Click);
			// 
			// EndAddr
			// 
			this.EndAddr.Location = new System.Drawing.Point(279, 111);
			this.EndAddr.Name = "EndAddr";
			this.EndAddr.Size = new System.Drawing.Size(50, 20);
			this.EndAddr.TabIndex = 23;
			this.EndAddr.TextAlign = System.Windows.Forms.HorizontalAlignment.Right;
			// 
			// StartAddr
			// 
			this.StartAddr.Location = new System.Drawing.Point(226, 111);
			this.StartAddr.Name = "StartAddr";
			this.StartAddr.Size = new System.Drawing.Size(50, 20);
			this.StartAddr.TabIndex = 22;
			this.StartAddr.TextAlign = System.Windows.Forms.HorizontalAlignment.Right;
			// 
			// btnPageErase
			// 
			this.btnPageErase.Location = new System.Drawing.Point(226, 155);
			this.btnPageErase.Name = "btnPageErase";
			this.btnPageErase.Size = new System.Drawing.Size(100, 23);
			this.btnPageErase.TabIndex = 21;
			this.btnPageErase.Text = "Page(s) Erase";
			this.btnPageErase.UseVisualStyleBackColor = true;
			this.btnPageErase.Click += new System.EventHandler(this.btnPageErase_Click);
			// 
			// FileName
			// 
			this.FileName.AcceptsTab = true;
			this.FileName.Location = new System.Drawing.Point(226, 85);
			this.FileName.Name = "FileName";
			this.FileName.Size = new System.Drawing.Size(206, 20);
			this.FileName.TabIndex = 20;
			// 
			// btnHalt
			// 
			this.btnHalt.Location = new System.Drawing.Point(431, 259);
			this.btnHalt.Name = "btnHalt";
			this.btnHalt.Size = new System.Drawing.Size(75, 23);
			this.btnHalt.TabIndex = 19;
			this.btnHalt.Text = "Halt";
			this.btnHalt.UseVisualStyleBackColor = true;
			this.btnHalt.Click += new System.EventHandler(this.btnHalt_Click);
			// 
			// btnGo
			// 
			this.btnGo.Location = new System.Drawing.Point(431, 233);
			this.btnGo.Name = "btnGo";
			this.btnGo.Size = new System.Drawing.Size(75, 23);
			this.btnGo.TabIndex = 18;
			this.btnGo.Text = "GO";
			this.btnGo.UseVisualStyleBackColor = true;
			this.btnGo.Click += new System.EventHandler(this.btnGo_Click);
			// 
			// btnReadSFR
			// 
			this.btnReadSFR.Location = new System.Drawing.Point(438, 135);
			this.btnReadSFR.Name = "btnReadSFR";
			this.btnReadSFR.Size = new System.Drawing.Size(100, 23);
			this.btnReadSFR.TabIndex = 17;
			this.btnReadSFR.Text = "Read SFR";
			this.btnReadSFR.UseVisualStyleBackColor = true;
			// 
			// btnReadRAM
			// 
			this.btnReadRAM.Location = new System.Drawing.Point(438, 109);
			this.btnReadRAM.Name = "btnReadRAM";
			this.btnReadRAM.Size = new System.Drawing.Size(100, 23);
			this.btnReadRAM.TabIndex = 16;
			this.btnReadRAM.Text = "Read RAM";
			this.btnReadRAM.UseVisualStyleBackColor = true;
			// 
			// btnReadXRAM
			// 
			this.btnReadXRAM.Location = new System.Drawing.Point(438, 83);
			this.btnReadXRAM.Name = "btnReadXRAM";
			this.btnReadXRAM.Size = new System.Drawing.Size(100, 23);
			this.btnReadXRAM.TabIndex = 15;
			this.btnReadXRAM.Text = "Read XRAM";
			this.btnReadXRAM.UseVisualStyleBackColor = true;
			// 
			// btnReadFlash
			// 
			this.btnReadFlash.Location = new System.Drawing.Point(438, 57);
			this.btnReadFlash.Name = "btnReadFlash";
			this.btnReadFlash.Size = new System.Drawing.Size(100, 23);
			this.btnReadFlash.TabIndex = 14;
			this.btnReadFlash.Text = "Read Flash";
			this.btnReadFlash.UseVisualStyleBackColor = true;
			this.btnReadFlash.Click += new System.EventHandler(this.btnReadFlash_Click);
			// 
			// btnWriteFlash
			// 
			this.btnWriteFlash.Location = new System.Drawing.Point(332, 57);
			this.btnWriteFlash.Name = "btnWriteFlash";
			this.btnWriteFlash.Size = new System.Drawing.Size(100, 23);
			this.btnWriteFlash.TabIndex = 13;
			this.btnWriteFlash.Text = "Write Flash";
			this.btnWriteFlash.UseVisualStyleBackColor = true;
			this.btnWriteFlash.Click += new System.EventHandler(this.btnWriteFlash_Click);
			// 
			// label4
			// 
			this.label4.AutoSize = true;
			this.label4.Location = new System.Drawing.Point(20, 140);
			this.label4.Name = "label4";
			this.label4.Size = new System.Drawing.Size(41, 13);
			this.label4.TabIndex = 12;
			this.label4.Text = "Device";
			this.label4.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
			// 
			// cbDevices
			// 
			this.cbDevices.AutoCompleteMode = System.Windows.Forms.AutoCompleteMode.Suggest;
			this.cbDevices.AutoCompleteSource = System.Windows.Forms.AutoCompleteSource.ListItems;
			this.cbDevices.FormattingEnabled = true;
			this.cbDevices.Location = new System.Drawing.Point(67, 137);
			this.cbDevices.Name = "cbDevices";
			this.cbDevices.Size = new System.Drawing.Size(85, 21);
			this.cbDevices.TabIndex = 11;
			this.cbDevices.SelectedIndexChanged += new System.EventHandler(this.cbDevices_SelectedIndexChanged);
			// 
			// label3
			// 
			this.label3.AutoSize = true;
			this.label3.Location = new System.Drawing.Point(6, 114);
			this.label3.Name = "label3";
			this.label3.Size = new System.Drawing.Size(55, 13);
			this.label3.TabIndex = 10;
			this.label3.Text = "Unique ID";
			// 
			// UniqueID
			// 
			this.UniqueID.Enabled = false;
			this.UniqueID.Location = new System.Drawing.Point(67, 111);
			this.UniqueID.Name = "UniqueID";
			this.UniqueID.Size = new System.Drawing.Size(36, 20);
			this.UniqueID.TabIndex = 9;
			this.UniqueID.TextAlign = System.Windows.Forms.HorizontalAlignment.Right;
			// 
			// label2
			// 
			this.label2.AutoSize = true;
			this.label2.Location = new System.Drawing.Point(13, 88);
			this.label2.Name = "label2";
			this.label2.Size = new System.Drawing.Size(48, 13);
			this.label2.TabIndex = 8;
			this.label2.Text = "Revision";
			// 
			// Revision
			// 
			this.Revision.Enabled = false;
			this.Revision.Location = new System.Drawing.Point(67, 85);
			this.Revision.Name = "Revision";
			this.Revision.Size = new System.Drawing.Size(36, 20);
			this.Revision.TabIndex = 7;
			this.Revision.TextAlign = System.Windows.Forms.HorizontalAlignment.Right;
			// 
			// label1
			// 
			this.label1.AutoSize = true;
			this.label1.Location = new System.Drawing.Point(6, 62);
			this.label1.Name = "label1";
			this.label1.Size = new System.Drawing.Size(55, 13);
			this.label1.TabIndex = 6;
			this.label1.Text = "Device ID";
			// 
			// DeviceID
			// 
			this.DeviceID.Enabled = false;
			this.DeviceID.Location = new System.Drawing.Point(67, 59);
			this.DeviceID.Name = "DeviceID";
			this.DeviceID.Size = new System.Drawing.Size(36, 20);
			this.DeviceID.TabIndex = 5;
			this.DeviceID.TextAlign = System.Windows.Forms.HorizontalAlignment.Right;
			// 
			// statusStrip
			// 
			this.statusStrip.Items.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.status,
            this.progress});
			this.statusStrip.Location = new System.Drawing.Point(0, 387);
			this.statusStrip.Name = "statusStrip";
			this.statusStrip.Size = new System.Drawing.Size(575, 22);
			this.statusStrip.TabIndex = 6;
			this.statusStrip.Text = "statusStrip1";
			// 
			// status
			// 
			this.status.Name = "status";
			this.status.Size = new System.Drawing.Size(458, 17);
			this.status.Spring = true;
			this.status.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
			// 
			// progress
			// 
			this.progress.Name = "progress";
			this.progress.Size = new System.Drawing.Size(100, 16);
			// 
			// openFileDialog
			// 
			this.openFileDialog.Filter = "Flash files|*.hex;*.bin|All files|*.*";
			this.openFileDialog.Title = "Select file to open";
			// 
			// saveFileDialog
			// 
			this.saveFileDialog.Filter = "Binary files|*.bin";
			this.saveFileDialog.Title = "Select file to save";
			// 
			// frmMain
			// 
			this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
			this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
			this.ClientSize = new System.Drawing.Size(575, 409);
			this.Controls.Add(this.statusStrip);
			this.Controls.Add(this.groupC2);
			this.Controls.Add(this.cbDTREnable);
			this.Controls.Add(this.btnStartStop);
			this.Controls.Add(this.cbAutoConnect);
			this.Controls.Add(this.cbPorts);
			this.Name = "frmMain";
			this.Text = "C2.Flash";
			this.Load += new System.EventHandler(this.frmMain_Load);
			this.FormClosed += new System.Windows.Forms.FormClosedEventHandler(this.frmMain_FormClosed);
			this.groupC2.ResumeLayout(false);
			this.groupC2.PerformLayout();
			this.statusStrip.ResumeLayout(false);
			this.statusStrip.PerformLayout();
			this.ResumeLayout(false);
			this.PerformLayout();

		}

		#endregion

		private System.Windows.Forms.ComboBox cbPorts;
		private System.Windows.Forms.CheckBox cbAutoConnect;
		private System.Windows.Forms.Button btnStartStop;
		private System.Windows.Forms.CheckBox cbDTREnable;
		private System.Windows.Forms.Button btnC2Target;
		private System.Windows.Forms.GroupBox groupC2;
		private System.Windows.Forms.TextBox DeviceID;
		private System.Windows.Forms.Label label1;
		private System.Windows.Forms.StatusStrip statusStrip;
		private System.Windows.Forms.ToolStripStatusLabel status;
		private System.Windows.Forms.Label label2;
		private System.Windows.Forms.TextBox Revision;
		private System.Windows.Forms.Label label3;
		private System.Windows.Forms.TextBox UniqueID;
		private System.Windows.Forms.Label label4;
		private System.Windows.Forms.ComboBox cbDevices;
		private System.Windows.Forms.Button btnReadSFR;
		private System.Windows.Forms.Button btnReadRAM;
		private System.Windows.Forms.Button btnReadXRAM;
		private System.Windows.Forms.Button btnReadFlash;
		private System.Windows.Forms.Button btnWriteFlash;
		private System.Windows.Forms.TextBox EndAddr;
		private System.Windows.Forms.TextBox StartAddr;
		private System.Windows.Forms.Button btnPageErase;
		private System.Windows.Forms.Button btnHalt;
		private System.Windows.Forms.Button btnGo;
		private System.Windows.Forms.ToolStripProgressBar progress;
		private System.Windows.Forms.Button btnDataWrite;
		private System.Windows.Forms.Button btnAddressWrite;
		private System.Windows.Forms.Label label5;
		private System.Windows.Forms.TextBox AddressWrite;
		private System.Windows.Forms.Button btnDeviceErase;
		private System.Windows.Forms.TextBox DataRead;
		private System.Windows.Forms.Button btnDataRead;
		private System.Windows.Forms.TextBox AddressRead;
		private System.Windows.Forms.Button btnAddressRead;
		private System.Windows.Forms.Label label6;
		private System.Windows.Forms.TextBox DataWrite;
		private System.Windows.Forms.Button btnDeviceErase04;
		private System.Windows.Forms.Label label8;
		private System.Windows.Forms.Label label7;
		private System.Windows.Forms.TextBox FileName;
		private System.Windows.Forms.OpenFileDialog openFileDialog;
		private System.Windows.Forms.SaveFileDialog saveFileDialog;
		private System.Windows.Forms.Button btnWriteFlashPartial;
		private System.Windows.Forms.Button btnVerify;
		private System.Windows.Forms.CheckBox cbAutoErase;
	}
}

