object SettingsForm: TSettingsForm
  Left = 33
  Top = 6
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Current Settings Panel'
  ClientHeight = 528
  ClientWidth = 353
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Arial'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 15
  object Label1: TLabel
    Left = 8
    Top = 472
    Width = 337
    Height = 49
    Alignment = taCenter
    AutoSize = False
    Caption = 
      'When a script is run, these settings are all initialised from th' +
      'e View and Processing menus and the RIC Control Panel, but can b' +
      'e changed through /V, /P, and /C directives in the script.'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = [fsItalic]
    ParentFont = False
    WordWrap = True
  end
  object Label8: TLabel
    Left = 8
    Top = 8
    Width = 81
    Height = 33
    Alignment = taCenter
    AutoSize = False
    Caption = 'View menu settings'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    Layout = tlCenter
    WordWrap = True
  end
  object Label9: TLabel
    Left = 8
    Top = 146
    Width = 81
    Height = 33
    Alignment = taCenter
    AutoSize = False
    Caption = 'Processing menu settings'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    Layout = tlCenter
    WordWrap = True
  end
  object Label10: TLabel
    Left = 8
    Top = 354
    Width = 81
    Height = 33
    Alignment = taCenter
    AutoSize = False
    Caption = 'RIC Control Panel settings'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    Layout = tlCenter
    WordWrap = True
  end
  object DisablePanel: TPanel
    Left = 104
    Top = 4
    Width = 245
    Height = 333
    BevelOuter = bvNone
    TabOrder = 0
    OnEnter = DisablePanelEnter
    OnExit = DisablePanelExit
    object CheckPunctChk: TCheckBox
      Left = 0
      Top = 144
      Width = 245
      Height = 17
      Caption = 'Check final punctuation on input && output'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
    end
    object SeqRadioGroup: TRadioGroup
      Left = 0
      Top = 164
      Width = 241
      Height = 53
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      Items.Strings = (
        'Responses selected sequentially'
        'Responses selected in random order')
      ParentFont = False
      TabOrder = 1
    end
    object EchoRadioGroup: TRadioGroup
      Left = 0
      Top = 220
      Width = 241
      Height = 53
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      Items.Strings = (
        'Echo active text if no keyword found'
        'Blank active text if no keyword found')
      ParentFont = False
      TabOrder = 2
    end
    object CaseRadioGroup: TRadioGroup
      Left = 0
      Top = 276
      Width = 241
      Height = 53
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      Items.Strings = (
        'Upper case output only'
        'Lower case output permitted')
      ParentFont = False
      TabOrder = 3
    end
    object SpeedRadioGroup: TRadioGroup
      Left = 0
      Top = 0
      Width = 241
      Height = 53
      Columns = 2
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      Items.Strings = (
        'Instant response'
        'Fast typing'
        'Medium typing'
        'Slow typing')
      ParentFont = False
      TabOrder = 4
    end
    object AnalysisRadioGroup: TRadioGroup
      Left = 0
      Top = 56
      Width = 241
      Height = 69
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      Items.Strings = (
        'View all analysis tables'
        'View transformation tables only'
        'Hide all analysis tables')
      ParentFont = False
      TabOrder = 5
    end
  end
  object GroupBox1: TGroupBox
    Left = 104
    Top = 348
    Width = 241
    Height = 109
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = [fsItalic]
    ParentFont = False
    TabOrder = 1
    object Label6: TLabel
      Left = 8
      Top = 40
      Width = 61
      Height = 17
      Alignment = taCenter
      AutoSize = False
      Caption = 'Control of:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsItalic]
      ParentFont = False
      Layout = tlCenter
      WordWrap = True
    end
    object Label3: TLabel
      Left = 92
      Top = 40
      Width = 37
      Height = 17
      Alignment = taCenter
      AutoSize = False
      Caption = 'Input'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      Layout = tlCenter
      WordWrap = True
    end
    object Label4: TLabel
      Left = 140
      Top = 40
      Width = 37
      Height = 17
      Alignment = taCenter
      AutoSize = False
      Caption = 'Output'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      Layout = tlCenter
      WordWrap = True
    end
    object Label5: TLabel
      Left = 188
      Top = 40
      Width = 37
      Height = 17
      Alignment = taCenter
      AutoSize = False
      Caption = 'Final'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      Layout = tlCenter
      WordWrap = True
    end
    object Label2: TLabel
      Left = 12
      Top = 60
      Width = 61
      Height = 17
      Alignment = taCenter
      AutoSize = False
      Caption = 'Iteration'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsItalic, fsUnderline]
      ParentFont = False
      Layout = tlCenter
      WordWrap = True
    end
    object Label7: TLabel
      Left = 12
      Top = 80
      Width = 61
      Height = 17
      Alignment = taCenter
      AutoSize = False
      Caption = 'Cycling'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsItalic, fsUnderline]
      ParentFont = False
      Layout = tlCenter
      WordWrap = True
    end
    object InItShowLbl: TLabel
      Left = 84
      Top = 60
      Width = 53
      Height = 17
      Alignment = taCenter
      AutoSize = False
      Caption = 'NO'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      Layout = tlCenter
      WordWrap = True
    end
    object OutItShowLbl: TLabel
      Left = 132
      Top = 60
      Width = 53
      Height = 17
      Alignment = taCenter
      AutoSize = False
      Caption = 'NO'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      Layout = tlCenter
      WordWrap = True
    end
    object FinItShowLbl: TLabel
      Left = 180
      Top = 60
      Width = 53
      Height = 17
      Alignment = taCenter
      AutoSize = False
      Caption = 'NO'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      Layout = tlCenter
      WordWrap = True
    end
    object InCyShowLbl: TLabel
      Left = 84
      Top = 80
      Width = 53
      Height = 17
      Alignment = taCenter
      AutoSize = False
      Caption = 'NO'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      Layout = tlCenter
      WordWrap = True
    end
    object OutCyShowLbl: TLabel
      Left = 132
      Top = 80
      Width = 53
      Height = 17
      Alignment = taCenter
      AutoSize = False
      Caption = 'NO'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      Layout = tlCenter
      WordWrap = True
    end
    object FinCyShowLbl: TLabel
      Left = 180
      Top = 80
      Width = 53
      Height = 17
      Alignment = taCenter
      AutoSize = False
      Caption = 'NO'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      Layout = tlCenter
      WordWrap = True
    end
    object Label14: TLabel
      Left = 96
      Top = 16
      Width = 65
      Height = 17
      Alignment = taCenter
      AutoSize = False
      Caption = 'Halt limits:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = [fsItalic]
      ParentFont = False
      Layout = tlCenter
      WordWrap = True
    end
    object LimitsShowLbl: TLabel
      Left = 160
      Top = 24
      Width = 73
      Height = 17
      Alignment = taCenter
      AutoSize = False
      Caption = '50000,5000'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      Layout = tlCenter
      WordWrap = True
    end
    object RecurShowChk: TCheckBox
      Left = 8
      Top = 16
      Width = 75
      Height = 17
      Alignment = taLeftJustify
      Caption = 'Recursion'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = [fsItalic, fsUnderline]
      ParentFont = False
      TabOrder = 0
      OnEnter = RecurShowChkEnter
      OnExit = RecurShowChkExit
    end
  end
  object RevertVBtn: TButton
    Left = 8
    Top = 48
    Width = 81
    Height = 33
    Caption = 'Revert to menu settings'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsItalic]
    ParentFont = False
    TabOrder = 2
    WordWrap = True
    OnClick = RevertVBtnClick
  end
  object RevertPBtn: TButton
    Left = 8
    Top = 184
    Width = 81
    Height = 33
    Caption = 'Revert to menu settings'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsItalic]
    ParentFont = False
    TabOrder = 3
    WordWrap = True
    OnClick = RevertPBtnClick
  end
  object RevertCBtn: TButton
    Left = 8
    Top = 392
    Width = 81
    Height = 49
    Caption = 'Revert to Control Panel settings'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsItalic]
    ParentFont = False
    TabOrder = 4
    WordWrap = True
    OnClick = RevertCBtnClick
  end
end
