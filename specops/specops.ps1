# Create a script block with all the code
$scriptBlock = {
    Add-Type -AssemblyName System.Windows.Forms
    Add-Type -AssemblyName System.Drawing
    Add-Type -AssemblyName Microsoft.VisualBasic

    # Create the form
    $form = New-Object System.Windows.Forms.Form
    $form.Text = "Spec Ops Helper"
    $form.Size = New-Object System.Drawing.Size(600, 650)
    $form.StartPosition = "CenterScreen"
    $form.BackColor = [System.Drawing.Color]::FromArgb(245, 245, 245)
    $form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedSingle
    $form.MaximizeBox = $false
    $form.Font = New-Object System.Drawing.Font("Segoe UI", 9)

    # Variables to store data
    $global:eventName = ""
    $global:imagePath = ""
    $global:clipboardImage = $null

    # Function to show custom event name dialog
    function Show-EventNameDialog {
        $dialog = New-Object System.Windows.Forms.Form
        $dialog.Text = "Set Event Name"
        $dialog.Size = New-Object System.Drawing.Size(400, 220)
        $dialog.StartPosition = "CenterScreen"
        $dialog.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedDialog
        $dialog.MaximizeBox = $false
        $dialog.MinimizeBox = $false
        $dialog.BackColor = [System.Drawing.Color]::FromArgb(45, 45, 48)
        $dialog.Font = New-Object System.Drawing.Font("Segoe UI", 9)
        
        # Header Panel
        $headerPanel = New-Object System.Windows.Forms.Panel
        $headerPanel.Location = New-Object System.Drawing.Point(0, 0)
        $headerPanel.Size = New-Object System.Drawing.Size(400, 60)
        $headerPanel.BackColor = [System.Drawing.Color]::FromArgb(37, 37, 40)
        
        # Title Label
        $lblDialogTitle = New-Object System.Windows.Forms.Label
        $lblDialogTitle.Location = New-Object System.Drawing.Point(15, 15)
        $lblDialogTitle.Size = New-Object System.Drawing.Size(370, 30)
        $lblDialogTitle.Text = "Enter Event Name"
        $lblDialogTitle.Font = New-Object System.Drawing.Font("Segoe UI", 12, [System.Drawing.FontStyle]::Bold)
        $lblDialogTitle.ForeColor = [System.Drawing.Color]::White
        $lblDialogTitle.BackColor = [System.Drawing.Color]::Transparent
        
        $headerPanel.Controls.Add($lblDialogTitle)
        
        # TextBox for input
        $txtEventName = New-Object System.Windows.Forms.TextBox
        $txtEventName.Location = New-Object System.Drawing.Point(20, 75)
        $txtEventName.Size = New-Object System.Drawing.Size(345, 30)
        $txtEventName.Font = New-Object System.Drawing.Font("Segoe UI", 10)
        $txtEventName.BackColor = [System.Drawing.Color]::FromArgb(60, 60, 65)
        $txtEventName.ForeColor = [System.Drawing.Color]::White
        $txtEventName.BorderStyle = [System.Windows.Forms.BorderStyle]::FixedSingle
        $txtEventName.Text = $global:eventName
        
        # Pre-fill if event name exists
        if ($global:eventName -ne "") {
            $txtEventName.Text = $global:eventName
            $txtEventName.SelectAll()
        }
        
        # OK Button
        $btnOK = New-Object System.Windows.Forms.Button
        $btnOK.Location = New-Object System.Drawing.Point(150, 125)
        $btnOK.Size = New-Object System.Drawing.Size(100, 35)
        $btnOK.Text = "OK"
        $btnOK.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
        $btnOK.BackColor = [System.Drawing.Color]::FromArgb(0, 122, 204)
        $btnOK.ForeColor = [System.Drawing.Color]::White
        $btnOK.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
        $btnOK.FlatAppearance.BorderSize = 0
        $btnOK.Cursor = [System.Windows.Forms.Cursors]::Hand
        $btnOK.DialogResult = [System.Windows.Forms.DialogResult]::OK
        
        # Cancel Button
        $btnCancel = New-Object System.Windows.Forms.Button
        $btnCancel.Location = New-Object System.Drawing.Point(260, 125)
        $btnCancel.Size = New-Object System.Drawing.Size(100, 35)
        $btnCancel.Text = "Cancel"
        $btnCancel.Font = New-Object System.Drawing.Font("Segoe UI", 10)
        $btnCancel.BackColor = [System.Drawing.Color]::FromArgb(100, 100, 105)
        $btnCancel.ForeColor = [System.Drawing.Color]::White
        $btnCancel.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
        $btnCancel.FlatAppearance.BorderSize = 0
        $btnCancel.Cursor = [System.Windows.Forms.Cursors]::Hand
        $btnCancel.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
        
        # Event handlers
        $txtEventName.Add_KeyDown({
            if ($_.KeyCode -eq 'Enter') {
                $btnOK.PerformClick()
            }
        })
        
        $dialog.Add_Shown({
            $txtEventName.Focus()
        })
        
        # Add controls to dialog
        $dialog.Controls.Add($headerPanel)
        $dialog.Controls.Add($txtEventName)
        $dialog.Controls.Add($btnOK)
        $dialog.Controls.Add($btnCancel)
        
        $dialog.AcceptButton = $btnOK
        $dialog.CancelButton = $btnCancel
        
        # Show dialog and return result
        $dialog.ShowDialog() | Out-Null
        if ($dialog.DialogResult -eq [System.Windows.Forms.DialogResult]::OK) {
            return $txtEventName.Text.Trim()
        }
        
        return $null
    }

    # Function to paste text and image with one click
    function PasteToDiscord {
        param(
            [string]$text,
            $image
        )
        
        if ($image -eq $null) {
            [System.Windows.Forms.MessageBox]::Show("No image to copy!", "Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error) | Out-Null
            return
        }
        
        try {
            # Format the text for Discord
            $formattedText = "**Event Name:** $text`n**Proof:** `n"
            
            # Copy text to clipboard first
            [System.Windows.Forms.Clipboard]::SetText($formattedText)
            
            [System.Windows.Forms.MessageBox]::Show("Click OK, then click in Discord where you want to paste. The text and image will be pasted automatically.", "Ready to Paste", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information) | Out-Null
            
            # Wait for user to click in Discord
            Start-Sleep -Seconds 2
            
            # Paste text
            [System.Windows.Forms.SendKeys]::SendWait("^v")
            Start-Sleep -Milliseconds 500
            
            # Copy image to clipboard
            [System.Windows.Forms.Clipboard]::SetImage($image)
            Start-Sleep -Milliseconds 200
            
            # Paste image
            [System.Windows.Forms.SendKeys]::SendWait("^v")
            
            [System.Windows.Forms.MessageBox]::Show("Done! Text and image should be pasted.", "Complete", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information) | Out-Null
        } catch {
            [System.Windows.Forms.MessageBox]::Show("Error: $($_.Exception.Message)", "Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error) | Out-Null
        }
    }

    # Function to update the result textbox
    function UpdateResult {
        $result = ""
        
        if ($global:eventName -ne "") {
            $result += "Event Name: $global:eventName`r`n`r`n"
        }
        
        if ($global:imagePath -ne "" -or $global:clipboardImage -ne $null) {
            $result += "Proof:`r`n[Image Attached]"
        }
        
        $txtResult.Text = $result
    }

    # Create header panel
    $headerPanel = New-Object System.Windows.Forms.Panel
    $headerPanel.Location = New-Object System.Drawing.Point(0, 0)
    $headerPanel.Size = New-Object System.Drawing.Size(600, 100)
    $headerPanel.BackColor = [System.Drawing.Color]::FromArgb(45, 45, 48)

    # Title label
    $lblTitle = New-Object System.Windows.Forms.Label
    $lblTitle.Location = New-Object System.Drawing.Point(20, 15)
    $lblTitle.Size = New-Object System.Drawing.Size(560, 30)
    $lblTitle.Text = "Spec Ops Helper"
    $lblTitle.Font = New-Object System.Drawing.Font("Segoe UI", 14, [System.Drawing.FontStyle]::Bold)
    $lblTitle.ForeColor = [System.Drawing.Color]::White
    $lblTitle.BackColor = [System.Drawing.Color]::Transparent

    # Subtitle label
    $lblSubtitle = New-Object System.Windows.Forms.Label
    $lblSubtitle.Location = New-Object System.Drawing.Point(20, 45)
    $lblSubtitle.Size = New-Object System.Drawing.Size(560, 40)
    $lblSubtitle.Text = "easy method to paste your events in discord"
    $lblSubtitle.Font = New-Object System.Drawing.Font("Segoe UI", 9)
    $lblSubtitle.ForeColor = [System.Drawing.Color]::FromArgb(180, 180, 180)
    $lblSubtitle.BackColor = [System.Drawing.Color]::Transparent

    $headerPanel.Controls.Add($lblTitle)
    $headerPanel.Controls.Add($lblSubtitle)

    # Create Event Name Button
    $btnEventName = New-Object System.Windows.Forms.Button
    $btnEventName.Location = New-Object System.Drawing.Point(25, 120)
    $btnEventName.Size = New-Object System.Drawing.Size(260, 45)
    $btnEventName.Text = "Set Event Name"
    $btnEventName.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Regular)
    $btnEventName.BackColor = [System.Drawing.Color]::FromArgb(0, 122, 204)
    $btnEventName.ForeColor = [System.Drawing.Color]::White
    $btnEventName.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
    $btnEventName.FlatAppearance.BorderSize = 0
    $btnEventName.Cursor = [System.Windows.Forms.Cursors]::Hand

    # Create Image Button
    $btnImage = New-Object System.Windows.Forms.Button
    $btnImage.Location = New-Object System.Drawing.Point(310, 120)
    $btnImage.Size = New-Object System.Drawing.Size(260, 45)
    $btnImage.Text = "Add Image"
    $btnImage.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Regular)
    $btnImage.BackColor = [System.Drawing.Color]::FromArgb(0, 122, 204)
    $btnImage.ForeColor = [System.Drawing.Color]::White
    $btnImage.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
    $btnImage.FlatAppearance.BorderSize = 0
    $btnImage.Cursor = [System.Windows.Forms.Cursors]::Hand

    # Create a label to show Event Name
    $lblEventName = New-Object System.Windows.Forms.Label
    $lblEventName.Location = New-Object System.Drawing.Point(25, 180)
    $lblEventName.Size = New-Object System.Drawing.Size(545, 25)
    $lblEventName.Text = "Event Name: Not set"
    $lblEventName.Font = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Regular)
    $lblEventName.ForeColor = [System.Drawing.Color]::FromArgb(100, 100, 100)

    # Create PictureBox for image preview with placeholder
    $pictureBox = New-Object System.Windows.Forms.PictureBox
    $pictureBox.Location = New-Object System.Drawing.Point(25, 215)
    $pictureBox.Size = New-Object System.Drawing.Size(545, 220)
    $pictureBox.BackColor = [System.Drawing.Color]::FromArgb(250, 250, 250)
    $pictureBox.BorderStyle = [System.Windows.Forms.BorderStyle]::None
    $pictureBox.SizeMode = [System.Windows.Forms.PictureBoxSizeMode]::Zoom

    # Create placeholder label for picture box
    $lblPlaceholder = New-Object System.Windows.Forms.Label
    $lblPlaceholder.Location = New-Object System.Drawing.Point(0, 0)
    $lblPlaceholder.Size = $pictureBox.Size
    $lblPlaceholder.Text = "No image selected"
    $lblPlaceholder.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter
    $lblPlaceholder.Font = New-Object System.Drawing.Font("Segoe UI", 11)
    $lblPlaceholder.ForeColor = [System.Drawing.Color]::FromArgb(180, 180, 180)
    $lblPlaceholder.BackColor = [System.Drawing.Color]::Transparent
    $pictureBox.Controls.Add($lblPlaceholder)

    # Create section label for preview
    $lblPreviewTitle = New-Object System.Windows.Forms.Label
    $lblPreviewTitle.Location = New-Object System.Drawing.Point(25, 445)
    $lblPreviewTitle.Size = New-Object System.Drawing.Size(545, 20)
    $lblPreviewTitle.Text = "Preview"
    $lblPreviewTitle.Font = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Bold)
    $lblPreviewTitle.ForeColor = [System.Drawing.Color]::FromArgb(60, 60, 60)

    # Create Result TextBox (for the final combined content)
    $txtResult = New-Object System.Windows.Forms.RichTextBox
    $txtResult.Location = New-Object System.Drawing.Point(25, 470)
    $txtResult.Size = New-Object System.Drawing.Size(545, 80)
    $txtResult.Font = New-Object System.Drawing.Font("Consolas", 9)
    $txtResult.ReadOnly = $true
    $txtResult.BackColor = [System.Drawing.Color]::White
    $txtResult.BorderStyle = [System.Windows.Forms.BorderStyle]::FixedSingle

    # Copy Button
    $btnCopy = New-Object System.Windows.Forms.Button
    $btnCopy.Location = New-Object System.Drawing.Point(25, 565)
    $btnCopy.Size = New-Object System.Drawing.Size(545, 35)
    $btnCopy.Text = "Copy to Clipboard && Paste to Discord"
    $btnCopy.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Regular)
    $btnCopy.BackColor = [System.Drawing.Color]::FromArgb(40, 167, 69)
    $btnCopy.ForeColor = [System.Drawing.Color]::White
    $btnCopy.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
    $btnCopy.FlatAppearance.BorderSize = 0
    $btnCopy.Cursor = [System.Windows.Forms.Cursors]::Hand

    # Event Name Button Click
    $btnEventName.Add_Click({
        $input = Show-EventNameDialog
        if ($input -ne $null -and $input -ne "") {
            $global:eventName = $input
            $lblEventName.Text = "Event Name: $input"
            $lblEventName.ForeColor = [System.Drawing.Color]::FromArgb(40, 40, 40)
            UpdateResult
        }
    })

    # Image Button Click (with context menu for paste option)
    $contextMenu = New-Object System.Windows.Forms.ContextMenuStrip
    $contextMenu.BackColor = [System.Drawing.Color]::White
    $contextMenu.ForeColor = [System.Drawing.Color]::FromArgb(40, 40, 40)

    $menuItemFile = New-Object System.Windows.Forms.ToolStripMenuItem
    $menuItemFile.Text = "Choose Image File..."
    $menuItemPaste = New-Object System.Windows.Forms.ToolStripMenuItem
    $menuItemPaste.Text = "Paste from Clipboard"

    $contextMenu.Items.Add($menuItemFile)
    $contextMenu.Items.Add($menuItemPaste)

    $btnImage.Add_Click({
        $contextMenu.Show($btnImage, 0, $btnImage.Height)
    })

    # Choose file menu item click
    $menuItemFile.Add_Click({
        $openFileDialog = New-Object System.Windows.Forms.OpenFileDialog
        $openFileDialog.Filter = "Image Files (*.jpg;*.jpeg;*.png;*.gif;*.bmp)|*.jpg;*.jpeg;*.png;*.gif;*.bmp|All Files (*.*)|*.*"
        $openFileDialog.Title = "Select an Image File"
        
        $result = $openFileDialog.ShowDialog()
        if ($result -eq [System.Windows.Forms.DialogResult]::OK) {
            $global:imagePath = $openFileDialog.FileName
            $global:clipboardImage = $null
            try {
                if ($pictureBox.Image -ne $null) {
                    $pictureBox.Image.Dispose()
                }
                $pictureBox.Image = [System.Drawing.Image]::FromFile($global:imagePath)
                $lblPlaceholder.Visible = $false
                UpdateResult
            } catch {
                [System.Windows.Forms.MessageBox]::Show("Error loading image: $($_.Exception.Message)", "Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error) | Out-Null
            }
        }
    })

    # Paste from clipboard menu item click
    $menuItemPaste.Add_Click({
        if ([System.Windows.Forms.Clipboard]::ContainsImage()) {
            try {
                $global:clipboardImage = [System.Windows.Forms.Clipboard]::GetImage()
                $global:imagePath = ""
                if ($pictureBox.Image -ne $null) {
                    $pictureBox.Image.Dispose()
                }
                $pictureBox.Image = $global:clipboardImage
                $lblPlaceholder.Visible = $false
                UpdateResult
            } catch {
                [System.Windows.Forms.MessageBox]::Show("Error pasting image: $($_.Exception.Message)", "Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error) | Out-Null
            }
        } else {
            [System.Windows.Forms.MessageBox]::Show("No image found in clipboard!", "No Image", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Warning) | Out-Null
        }
    })

    # Copy Button Click
    $btnCopy.Add_Click({
        if ($global:eventName -eq "") {
            [System.Windows.Forms.MessageBox]::Show("Nothing to copy! Please add event name and image first.", "Empty", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Warning) | Out-Null
            return
        }
        
        if ($pictureBox.Image -eq $null) {
            [System.Windows.Forms.MessageBox]::Show("Nothing to copy! Please add an image first.", "Empty", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Warning) | Out-Null
            return
        }
        
        PasteToDiscord -text $global:eventName -image $pictureBox.Image
    })

    # Add controls to form
    $form.Controls.Add($headerPanel)
    $form.Controls.Add($btnEventName)
    $form.Controls.Add($btnImage)
    $form.Controls.Add($lblEventName)
    $form.Controls.Add($pictureBox)
    $form.Controls.Add($lblPreviewTitle)
    $form.Controls.Add($txtResult)
    $form.Controls.Add($btnCopy)

    # Clean up event
    $form.Add_FormClosed({
        if ($pictureBox.Image -ne $null) {
            $pictureBox.Image.Dispose()
        }
    })

    # Show the form
    $form.Add_Shown({$form.Activate()})
    $form.ShowDialog() | Out-Null
}

# Execute the script block and discard all output
& $scriptBlock | Out-Null