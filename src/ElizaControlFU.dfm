object ControlForm: TControlForm
  Left = 392
  Top = 143
  HorzScrollBar.Visible = False
  VertScrollBar.Visible = False
  BorderIcons = [biMinimize, biMaximize]
  BorderStyle = bsDialog
  Caption = 'Recursion, Iteration, and Cycling Control Panel'
  ClientHeight = 469
  ClientWidth = 573
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Arial'
  Font.Style = []
  Icon.Data = {
    0000010001002020100000000000E80200001600000028000000200000004000
    0000010004000000000080020000000000000000000000000000000000000000
    000000008000008000000080800080000000800080008080000080808000C0C0
    C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF000000
    000000000000000000000000000000000000000000000000EEEE000000000000
    000000000000000EEEEEE00000000000000000000000000EE00EEE0000000000
    000000000000000EE000EE0000000000000000000000000EEE00EEE000000000
    0000000000000000EE000EE0000000000000000000000000EEE00EE000000000
    00000000000000000EEE0EE000000000000000000000000000EEEEE00000000E
    EE0000EEEEEEEEE0000EEEE0000000EEEEE00EEEEEEEEEEEE000EEE000000EEE
    0EEE0EEEEEEEE0EEEEEEEEEE00000EE000EEEEE000EEE000EEEEE0EE00000EE0
    000EEEE000EEE0000EE000EEE0000EE00000EEEE00EEE0000EEE000EEE000EEE
    E0000EEE00EEE00000EE0000EE000EEEEE000EEE000EEE0000EEE000EEE00EE0
    EEE000EE000EEE00000EE0000EE00EE00EEE00EEE00EEE00000EEE000EE00EE0
    00EE00EEE00EEE00EE00EE0000E00EEE000E00EEE00EEE00EEEEEEE0000000EE
    E0EE00EEE00000000EEEEEE00000000EEEEE00EEE000000000000EE000000000
    EEE000EEE000000000000000000000000000000EEE000E000000000000000000
    0000000EEE000EE0000000000000000000000000EE000EEE0000000000000000
    00000000EE0000EEE00000000000000000000000EE0000000000000000000000
    0000000EEE00000000000000000000000000000000000000000000000000FFFF
    FFFFFFFFF0FFFFFFE07FFFFFE63FFFFFE73FFFFFE31FFFFFF39FFFFFF19FFFFF
    F89FFFFFFC1FE3C01E1FC180071F8880400F9C1C704F9E1C79C79F0C78E3878C
    7CF3838E3C7191CE3E7998C63E399CC6333D8EC6301FC4C7F81FE0C7FF9FF1C7
    FFFFFFE3BFFFFFE39FFFFFF38FFFFFF3C7FFFFF3FFFFFFE3FFFFFFFFFFFF}
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 15
  object RecursionChk: TCheckBox
    Left = 8
    Top = 16
    Width = 357
    Height = 17
    Caption = 'Permit Recursion, Text Splitting and Recombining, using { ... }'
    Checked = True
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    State = cbChecked
    TabOrder = 0
    OnClick = RecursionChkClick
  end
  object OKBtn: TButton
    Left = 388
    Top = 8
    Width = 169
    Height = 33
    Caption = 'Close and Save Settings'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 1
    WordWrap = True
    OnClick = OKBtnClick
  end
  object IterCycleBtn: TButton
    Left = 8
    Top = 49
    Width = 349
    Height = 25
    Caption = 
      'Set '#39'unlimited'#39' options for input/output/final iteration && cycl' +
      'ing'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    OnClick = IterCycleBtnClick
  end
  object GroupBox7: TGroupBox
    Left = 8
    Top = 336
    Width = 557
    Height = 125
    TabOrder = 3
    object Label4: TLabel
      Left = 12
      Top = 92
      Width = 81
      Height = 15
      Caption = 'with message:'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label3: TLabel
      Left = 12
      Top = 17
      Width = 292
      Height = 15
      Caption = 'Halt processing if calls to matching algorithm exceed:'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object HaltLbl: TLabel
      Left = 104
      Top = 89
      Width = 441
      Height = 24
      AutoSize = False
      Color = clWhite
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      Layout = tlCenter
    end
    object HaltHelpBtn: TSpeedButton
      Left = 521
      Top = 89
      Width = 24
      Height = 24
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        04000000000000010000120B0000120B00001000000000000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        3333333333FFFFF3333333333F797F3333333333F737373FF333333BFB999BFB
        33333337737773773F3333BFBF797FBFB33333733337333373F33BFBFBFBFBFB
        FB3337F33333F33337F33FBFBFB9BFBFBF3337333337F333373FFBFBFBF97BFB
        FBF37F333337FF33337FBFBFBFB99FBFBFB37F3333377FF3337FFBFBFBFB99FB
        FBF37F33333377FF337FBFBF77BF799FBFB37F333FF3377F337FFBFB99FB799B
        FBF373F377F3377F33733FBF997F799FBF3337F377FFF77337F33BFBF99999FB
        FB33373F37777733373333BFBF999FBFB3333373FF77733F7333333BFBFBFBFB
        3333333773FFFF77333333333FBFBF3333333333377777333333}
      NumGlyphs = 2
      OnClick = HaltHelpBtnClick
    end
    object Label15: TLabel
      Left = 52
      Top = 49
      Width = 255
      Height = 15
      Caption = 'or if sequential memory checking calls exceed:'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object MatchLimitSpin: TSpinEdit
      Left = 319
      Top = 15
      Width = 71
      Height = 26
      EditorEnabled = False
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      Increment = 500
      MaxValue = 9990000
      MinValue = 500
      ParentFont = False
      TabOrder = 0
      Value = 5000
    end
    object HaltBtn: TButton
      Left = 428
      Top = 24
      Width = 97
      Height = 41
      Caption = 'show halt action (if defined)'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = [fsItalic]
      ParentFont = False
      TabOrder = 1
      WordWrap = True
      OnClick = HaltBtnClick
    end
    object MemCheckSpin: TSpinEdit
      Left = 319
      Top = 47
      Width = 71
      Height = 26
      EditorEnabled = False
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      Increment = 50
      MaxValue = 9990000
      MinValue = 50
      ParentFont = False
      TabOrder = 2
      Value = 500
    end
  end
  object GroupBox8: TGroupBox
    Left = 8
    Top = 84
    Width = 557
    Height = 249
    TabOrder = 4
    object Label1: TLabel
      Left = 200
      Top = 20
      Width = 113
      Height = 37
      Alignment = taCenter
      AutoSize = False
      Caption = 'Input Transformations'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      WordWrap = True
    end
    object Label2: TLabel
      Left = 320
      Top = 20
      Width = 113
      Height = 37
      Alignment = taCenter
      AutoSize = False
      Caption = 'Output Transformations'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      WordWrap = True
    end
    object Label5: TLabel
      Left = 440
      Top = 20
      Width = 113
      Height = 37
      Alignment = taCenter
      AutoSize = False
      Caption = 'Final Transformations'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      WordWrap = True
    end
    object Label6: TLabel
      Left = 12
      Top = 52
      Width = 113
      Height = 17
      AutoSize = False
      Caption = 'Iteration Control'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      WordWrap = True
    end
    object Label8: TLabel
      Left = 28
      Top = 76
      Width = 153
      Height = 17
      AutoSize = False
      Caption = 'Permit unlimited iteration'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = [fsItalic]
      ParentFont = False
      WordWrap = True
    end
    object Label10: TLabel
      Left = 28
      Top = 96
      Width = 177
      Height = 17
      AutoSize = False
      Caption = 'Undo iterations on reaching ...'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = [fsItalic]
      ParentFont = False
      WordWrap = True
    end
    object Label12: TLabel
      Left = 28
      Top = 116
      Width = 153
      Height = 17
      AutoSize = False
      Caption = 'Prevent iteration entirely'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = [fsItalic]
      ParentFont = False
      WordWrap = True
    end
    object Label7: TLabel
      Left = 12
      Top = 148
      Width = 113
      Height = 17
      AutoSize = False
      Caption = 'Cycling Control'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      WordWrap = True
    end
    object Label9: TLabel
      Left = 28
      Top = 172
      Width = 145
      Height = 17
      AutoSize = False
      Caption = 'Permit unlimited cycling'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = [fsItalic]
      ParentFont = False
      WordWrap = True
    end
    object Label11: TLabel
      Left = 28
      Top = 192
      Width = 177
      Height = 17
      AutoSize = False
      Caption = 'Undo cycling on reaching ...'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = [fsItalic]
      ParentFont = False
      WordWrap = True
    end
    object Label13: TLabel
      Left = 28
      Top = 212
      Width = 153
      Height = 17
      AutoSize = False
      Caption = 'Prevent cycling entirely'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = [fsItalic]
      ParentFont = False
      WordWrap = True
    end
    object GroupBox2: TGroupBox
      Left = 328
      Top = 60
      Width = 97
      Height = 81
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsItalic]
      ParentFont = False
      TabOrder = 0
      object OutputIterOnRadio: TRadioButton
        Left = 8
        Top = 16
        Width = 17
        Height = 17
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
      end
      object OutputIterUndoRadio: TRadioButton
        Left = 8
        Top = 36
        Width = 17
        Height = 17
        Enabled = False
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
      end
      object OutputIterOffRadio: TRadioButton
        Left = 8
        Top = 56
        Width = 17
        Height = 17
        Checked = True
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 2
        TabStop = True
      end
      object OutputIterSpin: TSpinEdit
        Left = 38
        Top = 33
        Width = 49
        Height = 24
        EditorEnabled = False
        Enabled = False
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        MaxValue = 999
        MinValue = 2
        ParentFont = False
        TabOrder = 3
        Value = 10
      end
    end
    object GroupBox4: TGroupBox
      Left = 448
      Top = 60
      Width = 97
      Height = 81
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsItalic]
      ParentFont = False
      TabOrder = 1
      object FinalIterOnRadio: TRadioButton
        Left = 8
        Top = 16
        Width = 17
        Height = 17
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
      end
      object FinalIterUndoRadio: TRadioButton
        Left = 8
        Top = 36
        Width = 17
        Height = 17
        Enabled = False
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
      end
      object FinalIterOffRadio: TRadioButton
        Left = 8
        Top = 56
        Width = 17
        Height = 17
        Checked = True
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 2
        TabStop = True
      end
      object FinalIterSpin: TSpinEdit
        Left = 38
        Top = 33
        Width = 49
        Height = 24
        EditorEnabled = False
        Enabled = False
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        MaxValue = 999
        MinValue = 2
        ParentFont = False
        TabOrder = 3
        Value = 10
      end
    end
    object GroupBox1: TGroupBox
      Left = 208
      Top = 60
      Width = 97
      Height = 81
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsItalic]
      ParentFont = False
      TabOrder = 2
      object InputIterOnRadio: TRadioButton
        Left = 8
        Top = 16
        Width = 17
        Height = 17
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
      end
      object InputIterUndoRadio: TRadioButton
        Left = 8
        Top = 36
        Width = 17
        Height = 17
        Enabled = False
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
      end
      object InputIterOffRadio: TRadioButton
        Left = 8
        Top = 56
        Width = 17
        Height = 17
        Checked = True
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 2
        TabStop = True
      end
      object InputIterSpin: TSpinEdit
        Left = 38
        Top = 33
        Width = 49
        Height = 24
        EditorEnabled = False
        Enabled = False
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        MaxValue = 999
        MinValue = 2
        ParentFont = False
        TabOrder = 3
        Value = 10
      end
    end
    object GroupBox5: TGroupBox
      Left = 328
      Top = 156
      Width = 97
      Height = 81
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsItalic]
      ParentFont = False
      TabOrder = 3
      object OutputCycleOnRadio: TRadioButton
        Left = 8
        Top = 16
        Width = 17
        Height = 17
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
      end
      object OutputCycleUndoRadio: TRadioButton
        Left = 8
        Top = 36
        Width = 17
        Height = 17
        Enabled = False
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
      end
      object OutputCycleOffRadio: TRadioButton
        Left = 8
        Top = 56
        Width = 17
        Height = 17
        Checked = True
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 2
        TabStop = True
      end
      object OutputCycleSpin: TSpinEdit
        Left = 38
        Top = 33
        Width = 49
        Height = 24
        EditorEnabled = False
        Enabled = False
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        MaxValue = 999
        MinValue = 2
        ParentFont = False
        TabOrder = 3
        Value = 10
      end
    end
    object GroupBox6: TGroupBox
      Left = 448
      Top = 156
      Width = 97
      Height = 81
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsItalic]
      ParentFont = False
      TabOrder = 4
      object FinalCycleOnRadio: TRadioButton
        Left = 8
        Top = 16
        Width = 17
        Height = 17
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
      end
      object FinalCycleUndoRadio: TRadioButton
        Left = 8
        Top = 36
        Width = 17
        Height = 17
        Enabled = False
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
      end
      object FinalCycleOffRadio: TRadioButton
        Left = 8
        Top = 56
        Width = 17
        Height = 17
        Checked = True
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 2
        TabStop = True
      end
      object FinalCycleSpin: TSpinEdit
        Left = 38
        Top = 33
        Width = 49
        Height = 24
        EditorEnabled = False
        Enabled = False
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        MaxValue = 999
        MinValue = 2
        ParentFont = False
        TabOrder = 3
        Value = 10
      end
    end
    object GroupBox3: TGroupBox
      Left = 208
      Top = 156
      Width = 97
      Height = 81
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsItalic]
      ParentFont = False
      TabOrder = 5
      object InputCycleOnRadio: TRadioButton
        Left = 8
        Top = 16
        Width = 17
        Height = 17
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
      end
      object InputCycleUndoRadio: TRadioButton
        Left = 8
        Top = 36
        Width = 17
        Height = 17
        Enabled = False
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
      end
      object InputCycleOffRadio: TRadioButton
        Left = 8
        Top = 56
        Width = 17
        Height = 17
        Checked = True
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 2
        TabStop = True
      end
      object InputCycleSpin: TSpinEdit
        Left = 38
        Top = 33
        Width = 49
        Height = 24
        EditorEnabled = False
        Enabled = False
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        MaxValue = 999
        MinValue = 2
        ParentFont = False
        TabOrder = 3
        Value = 10
      end
    end
  end
  object CancelBtn: TButton
    Left = 428
    Top = 49
    Width = 89
    Height = 25
    Caption = 'Cancel'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 5
    OnClick = CancelBtnClick
  end
end
