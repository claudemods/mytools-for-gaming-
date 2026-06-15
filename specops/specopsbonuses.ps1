Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$form = New-Object System.Windows.Forms.Form
$form.Text = "Spec Ops Bonus Help"
$form.Size = New-Object System.Drawing.Size(850,800)
$form.StartPosition = "CenterScreen"
$form.BackColor = [System.Drawing.Color]::FromArgb(10,10,40)
$form.ForeColor = [System.Drawing.Color]::White

# Title
$titleLabel = New-Object System.Windows.Forms.Label
$titleLabel.Text = "SPEC OPS BONUS HELP"
$titleLabel.Location = New-Object System.Drawing.Point(20,10)
$titleLabel.Size = New-Object System.Drawing.Size(790,30)
$titleLabel.ForeColor = [System.Drawing.Color]::Cyan
$titleLabel.Font = New-Object System.Drawing.Font("Consolas", 16, [System.Drawing.FontStyle]::Bold)
$titleLabel.TextAlign = "MiddleCenter"
$form.Controls.Add($titleLabel)

# Agent name button
$agentBtn = New-Object System.Windows.Forms.Button
$agentBtn.Text = "AGENT NAME"
$agentBtn.Location = New-Object System.Drawing.Point(20,45)
$agentBtn.Size = New-Object System.Drawing.Size(180,28)
$agentBtn.BackColor = [System.Drawing.Color]::FromArgb(255,140,0)
$agentBtn.ForeColor = [System.Drawing.Color]::Black
$agentBtn.Font = New-Object System.Drawing.Font("Consolas", 10, [System.Drawing.FontStyle]::Bold)
$agentBtn.FlatStyle = "Flat"
$agentBtn.FlatAppearance.BorderSize = 0
$form.Controls.Add($agentBtn)

$agentLabel = New-Object System.Windows.Forms.Label
$agentLabel.Text = ""
$agentLabel.Location = New-Object System.Drawing.Point(210,45)
$agentLabel.Size = New-Object System.Drawing.Size(600,28)
$agentLabel.ForeColor = [System.Drawing.Color]::Orange
$agentLabel.Font = New-Object System.Drawing.Font("Consolas", 12, [System.Drawing.FontStyle]::Bold)
$agentLabel.TextAlign = "MiddleLeft"
$form.Controls.Add($agentLabel)

$global:agentName = ""

# Custom themed input box function
function Show-ThemedInputBox {
    $inputForm = New-Object System.Windows.Forms.Form
    $inputForm.Text = "Agent Name"
    $inputForm.Size = New-Object System.Drawing.Size(380,180)
    $inputForm.StartPosition = "CenterScreen"
    $inputForm.BackColor = [System.Drawing.Color]::FromArgb(15,15,60)
    $inputForm.ForeColor = [System.Drawing.Color]::White
    $inputForm.FormBorderStyle = "FixedDialog"
    $inputForm.MaximizeBox = $false
    $inputForm.MinimizeBox = $false
    
    # Label
    $label = New-Object System.Windows.Forms.Label
    $label.Text = "Enter agent name:"
    $label.Location = New-Object System.Drawing.Point(20,20)
    $label.Size = New-Object System.Drawing.Size(320,25)
    $label.ForeColor = [System.Drawing.Color]::Cyan
    $label.Font = New-Object System.Drawing.Font("Consolas", 11, [System.Drawing.FontStyle]::Bold)
    $inputForm.Controls.Add($label)
    
    # TextBox
    $textBox = New-Object System.Windows.Forms.TextBox
    $textBox.Location = New-Object System.Drawing.Point(20,50)
    $textBox.Size = New-Object System.Drawing.Size(320,28)
    $textBox.BackColor = [System.Drawing.Color]::FromArgb(10,10,40)
    $textBox.ForeColor = [System.Drawing.Color]::White
    $textBox.BorderStyle = "FixedSingle"
    $textBox.Font = New-Object System.Drawing.Font("Consolas", 12)
    $inputForm.Controls.Add($textBox)
    
    # OK Button
    $okBtn = New-Object System.Windows.Forms.Button
    $okBtn.Text = "OK"
    $okBtn.Location = New-Object System.Drawing.Point(120,95)
    $okBtn.Size = New-Object System.Drawing.Size(100,35)
    $okBtn.BackColor = [System.Drawing.Color]::FromArgb(0,120,255)
    $okBtn.ForeColor = [System.Drawing.Color]::White
    $okBtn.Font = New-Object System.Drawing.Font("Consolas", 11, [System.Drawing.FontStyle]::Bold)
    $okBtn.FlatStyle = "Flat"
    $okBtn.FlatAppearance.BorderSize = 0
    $okBtn.DialogResult = [System.Windows.Forms.DialogResult]::OK
    $inputForm.Controls.Add($okBtn)
    
    # Cancel Button
    $cancelBtn = New-Object System.Windows.Forms.Button
    $cancelBtn.Text = "CANCEL"
    $cancelBtn.Location = New-Object System.Drawing.Point(230,95)
    $cancelBtn.Size = New-Object System.Drawing.Size(100,35)
    $cancelBtn.BackColor = [System.Drawing.Color]::FromArgb(200,50,50)
    $cancelBtn.ForeColor = [System.Drawing.Color]::White
    $cancelBtn.Font = New-Object System.Drawing.Font("Consolas", 11, [System.Drawing.FontStyle]::Bold)
    $cancelBtn.FlatStyle = "Flat"
    $cancelBtn.FlatAppearance.BorderSize = 0
    $cancelBtn.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
    $inputForm.Controls.Add($cancelBtn)
    
    $inputForm.AcceptButton = $okBtn
    $inputForm.CancelButton = $cancelBtn
    
    $result = $inputForm.ShowDialog()
    
    if ($result -eq [System.Windows.Forms.DialogResult]::OK) {
        return $textBox.Text
    } else {
        return ""
    }
}

$agentBtn.Add_Click({
    $name = Show-ThemedInputBox
    if ($name -ne "") {
        $global:agentName = $name
        $agentLabel.Text = "Agent: $name"
    }
})

# Input box
$inputBox = New-Object System.Windows.Forms.TextBox
$inputBox.Location = New-Object System.Drawing.Point(20,80)
$inputBox.Size = New-Object System.Drawing.Size(790,200)
$inputBox.Multiline = $true
$inputBox.BackColor = [System.Drawing.Color]::FromArgb(15,15,60)
$inputBox.ForeColor = [System.Drawing.Color]::White
$inputBox.BorderStyle = "FixedSingle"
$inputBox.Font = New-Object System.Drawing.Font("Consolas", 10)
$inputBox.ScrollBars = "Vertical"
$form.Controls.Add($inputBox)

# Buttons row
$button = New-Object System.Windows.Forms.Button
$button.Text = "ANALYZE"
$button.Location = New-Object System.Drawing.Point(20,290)
$button.Size = New-Object System.Drawing.Size(250,38)
$button.BackColor = [System.Drawing.Color]::FromArgb(0,180,0)
$button.ForeColor = [System.Drawing.Color]::White
$button.Font = New-Object System.Drawing.Font("Consolas", 13, [System.Drawing.FontStyle]::Bold)
$button.FlatStyle = "Flat"
$button.FlatAppearance.BorderSize = 0
$form.Controls.Add($button)

$clearBtn = New-Object System.Windows.Forms.Button
$clearBtn.Text = "CLEAR"
$clearBtn.Location = New-Object System.Drawing.Point(285,290)
$clearBtn.Size = New-Object System.Drawing.Size(250,38)
$clearBtn.BackColor = [System.Drawing.Color]::FromArgb(200,50,50)
$clearBtn.ForeColor = [System.Drawing.Color]::White
$clearBtn.Font = New-Object System.Drawing.Font("Consolas", 13, [System.Drawing.FontStyle]::Bold)
$clearBtn.FlatStyle = "Flat"
$clearBtn.FlatAppearance.BorderSize = 0
$form.Controls.Add($clearBtn)

$copyBtn = New-Object System.Windows.Forms.Button
$copyBtn.Text = "COPY OUTPUT"
$copyBtn.Location = New-Object System.Drawing.Point(550,290)
$copyBtn.Size = New-Object System.Drawing.Size(260,38)
$copyBtn.BackColor = [System.Drawing.Color]::FromArgb(0,120,255)
$copyBtn.ForeColor = [System.Drawing.Color]::White
$copyBtn.Font = New-Object System.Drawing.Font("Consolas", 13, [System.Drawing.FontStyle]::Bold)
$copyBtn.FlatStyle = "Flat"
$copyBtn.FlatAppearance.BorderSize = 0
$form.Controls.Add($copyBtn)

# Results
$listBox = New-Object System.Windows.Forms.ListBox
$listBox.Location = New-Object System.Drawing.Point(20,338)
$listBox.Size = New-Object System.Drawing.Size(790,335)
$listBox.BackColor = [System.Drawing.Color]::FromArgb(15,15,60)
$listBox.ForeColor = [System.Drawing.Color]::White
$listBox.BorderStyle = "FixedSingle"
$listBox.Font = New-Object System.Drawing.Font("Consolas", 10)
$listBox.HorizontalScrollbar = $true
$form.Controls.Add($listBox)

# Total label
$totalLabel = New-Object System.Windows.Forms.Label
$totalLabel.Location = New-Object System.Drawing.Point(20,678)
$totalLabel.Size = New-Object System.Drawing.Size(790,25)
$totalLabel.ForeColor = [System.Drawing.Color]::Yellow
$totalLabel.Font = New-Object System.Drawing.Font("Consolas", 13, [System.Drawing.FontStyle]::Bold)
$totalLabel.TextAlign = "MiddleRight"
$form.Controls.Add($totalLabel)

# Save Log button - With better color
$saveLogBtn = New-Object System.Windows.Forms.Button
$saveLogBtn.Text = "SAVE LOG"
$saveLogBtn.Location = New-Object System.Drawing.Point(20,712)
$saveLogBtn.Size = New-Object System.Drawing.Size(790,35)
$saveLogBtn.BackColor = [System.Drawing.Color]::FromArgb(128,0,128)
$saveLogBtn.ForeColor = [System.Drawing.Color]::White
$saveLogBtn.Font = New-Object System.Drawing.Font("Consolas", 12, [System.Drawing.FontStyle]::Bold)
$saveLogBtn.FlatStyle = "Flat"
$saveLogBtn.FlatAppearance.BorderSize = 0
$form.Controls.Add($saveLogBtn)

function Strip-Formatting($txt) {
    $txt = $txt -replace '#+\s*', ''
    $txt = $txt -replace '\*', ''
    $txt = $txt -replace '^\s*-\s*', ''
    $txt = $txt -replace '\s*By\s+\S+(\s+\S+)*', ''
    $txt = $txt -replace '\s+', ' '
    $txt = $txt.Trim()
    return $txt
}

function Count-Matches($txt, $word) {
    $count = 0
    $temp = $txt
    while ($temp.Contains($word)) {
        $count++
        $index = $temp.IndexOf($word)
        $temp = $temp.Substring($index + $word.Length)
    }
    return $count
}

# Save log button click event
$saveLogBtn.Add_Click({
    $currentDir = Get-Location
    $logPath = Join-Path $currentDir "log.txt"
    
    $logContent = ""
    foreach ($item in $listBox.Items) {
        $logContent += $item + "`r`n"
    }
    if ($totalLabel.Text -ne "") {
        $logContent += "`r`n" + $totalLabel.Text
    }
    
    try {
        $logContent | Out-File -FilePath $logPath -Encoding UTF8
        [System.Windows.Forms.MessageBox]::Show("Log saved to:`n$logPath", "Saved", "OK", "Information")
    } catch {
        [System.Windows.Forms.MessageBox]::Show("Error saving log: $_", "Error", "OK", "Error")
    }
})

$button.Add_Click({
    $listBox.Items.Clear()
    $totalLabel.Text = ""
    
    $raw = $inputBox.Text
    
    $lines = $raw -split "`r`n|`n"
    $cleanedLines = @()
    foreach ($line in $lines) {
        $clean = Strip-Formatting $line
        if ($clean -ne "") {
            $cleanedLines += $clean
        }
    }
    $text = ($cleanedLines -join " ") -replace '\s+', ' '
    $textLower = $text.ToLower()
    
    # Agent name
    if ($global:agentName -ne "") {
        $listBox.Items.Add("Agent: $global:agentName")
        $listBox.Items.Add("")
    }
    
    $listBox.Items.Add("--- RESULTS ---")
    $listBox.Items.Add("")
    
    $total = 0
    $found = $false
    
    # Cannabis Busted - $1,500 Each
    $c = Count-Matches $textLower "cannabis busted"
    if ($c -gt 0) { $st = 1500 * $c; $listBox.Items.Add(("Cannabis Busted".PadRight(28) + "x" + $c.ToString().PadRight(8) + "$" + $st.ToString("N0"))); $total += $st; $found = $true }
    
    # Contraband Seized - $3,500 Each
    $c = Count-Matches $textLower "contraband seized"
    if ($c -gt 0) { $st = 3500 * $c; $listBox.Items.Add(("Contraband Seized".PadRight(28) + "x" + $c.ToString().PadRight(8) + "$" + $st.ToString("N0"))); $total += $st; $found = $true }
    
    # 3-4 Star Arrest - $15,000
    $c = Count-Matches $textLower "3-4 star arrest"
    if ($c -gt 0) { $st = 15000 * $c; $listBox.Items.Add(("3-4 Star Arrest".PadRight(28) + "x" + $c.ToString().PadRight(8) + "$" + $st.ToString("N0"))); $total += $st; $found = $true }
    
    # 5 Star Arrest - $20,000
    $c = Count-Matches $textLower "5 star arrest"
    if ($c -gt 0) { $st = 20000 * $c; $listBox.Items.Add(("5 Star Arrest".PadRight(28) + "x" + $c.ToString().PadRight(8) + "$" + $st.ToString("N0"))); $total += $st; $found = $true }
    
    # Warrants Executed - $50,000
    $c = Count-Matches $textLower "warrants executed"
    if ($c -gt 0) { $st = 50000 * $c; $listBox.Items.Add(("Warrants Executed".PadRight(28) + "x" + $c.ToString().PadRight(8) + "$" + $st.ToString("N0"))); $total += $st; $found = $true }
    
    # Official Events - $6,000 Each
    $officialEvents = @(
        @{D="FZ raids"; S=@("fz raid")},
        @{D="Black Market Raid"; S=@("black market raid")},
        @{D="Subs"; S=@("subs")},
        @{D="Vehicle theft"; S=@("vehicle theft")},
        @{D="Gang Raid"; S=@("gang raid")},
        @{D="Informant"; S=@("informant")},
        @{D="Aircraft carrier"; S=@("aircraft carrier")},
        @{D="Prison Protection"; S=@("prison protection")},
        @{D="Data Breach"; S=@("data breach", "hacker attack")},
        @{D="Bank Protection"; S=@("bank protection")},
        @{D="Gun Store"; S=@("gun store")},
        @{D="24/7 Store"; S=@("store robbery", "24/7 store")},
        @{D="Dealer Recruitment"; S=@("dealer recruitment")}
    )
    
    foreach ($evt in $officialEvents) {
        $c = 0
        foreach ($s in $evt.S) {
            $c += Count-Matches $textLower $s
        }
        if ($c -gt 0) {
            $st = 6000 * $c
            $listBox.Items.Add(($evt.D.PadRight(28) + "x" + $c.ToString().PadRight(8) + "$" + $st.ToString("N0")))
            $total += $st
            $found = $true
        }
    }
    
    if ($found) {
        $totalLabel.Text = "TOTAL: $" + $total.ToString("N0")
    } else {
        $listBox.Items.Add("No matches found")
    }
})

$clearBtn.Add_Click({
    $inputBox.Text = ""
    $listBox.Items.Clear()
    $totalLabel.Text = ""
})

$copyBtn.Add_Click({
    $output = ""
    foreach ($item in $listBox.Items) {
        $output += $item + "`r`n"
    }
    if ($totalLabel.Text -ne "") {
        $output += "`r`n" + $totalLabel.Text
    }
    [System.Windows.Forms.Clipboard]::SetText($output)
    [System.Windows.Forms.MessageBox]::Show("Output copied to clipboard!", "Copied", "OK", "Information")
})

# Fix: Suppress cancel dialog on exit
$form.Add_FormClosing({
    $_.Cancel = $false
})

$null = $form.ShowDialog()
