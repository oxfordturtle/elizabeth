object ElizaEditFindForm: TElizaEditFindForm
  Left = 19
  Top = 0
  HorzScrollBar.Visible = False
  VertScrollBar.Visible = False
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = 'Script Editor Find & Replace'
  ClientHeight = 241
  ClientWidth = 545
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  FormStyle = fsStayOnTop
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
  Position = poScreenCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 14
  object Label2: TLabel
    Left = 31
    Top = 8
    Width = 96
    Height = 25
    AutoSize = False
    Caption = 'Find the text:'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Arial'
    Font.Style = [fsItalic]
    ParentFont = False
    Layout = tlCenter
  end
  object Label1: TLabel
    Left = 424
    Top = 78
    Width = 113
    Height = 17
    AutoSize = False
    Caption = 'Use '#39'##'#39' for end of line'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsItalic]
    ParentFont = False
    WordWrap = True
  end
  object ReplaceEdit: TEdit
    Left = 12
    Top = 108
    Width = 521
    Height = 26
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
  end
  object FindEdit: TEdit
    Left = 12
    Top = 36
    Width = 521
    Height = 26
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
  end
  object ReplaceChk: TCheckBox
    Left = 12
    Top = 83
    Width = 119
    Height = 19
    Caption = 'Replace with:'
    Checked = True
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Arial'
    Font.Style = [fsItalic]
    ParentFont = False
    State = cbChecked
    TabOrder = 2
    OnClick = ReplaceChkClick
  end
  object FindNextBtn: TButton
    Left = 12
    Top = 164
    Width = 137
    Height = 25
    Caption = 'Find Next'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Arial'
    Font.Style = [fsItalic]
    ParentFont = False
    TabOrder = 3
    OnClick = FindNextBtnClick
  end
  object ReplaceBtn: TButton
    Left = 172
    Top = 164
    Width = 121
    Height = 25
    Caption = 'Replace'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Arial'
    Font.Style = [fsItalic]
    ParentFont = False
    TabOrder = 4
    OnClick = ReplaceBtnClick
  end
  object CancelBtn: TButton
    Left = 460
    Top = 164
    Width = 73
    Height = 25
    Caption = 'Cancel'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Arial'
    Font.Style = [fsItalic]
    ParentFont = False
    TabOrder = 5
    OnClick = CancelBtnClick
  end
  object ReplFindChk: TCheckBox
    Left = 180
    Top = 204
    Width = 113
    Height = 17
    Caption = '... then find next'
    Checked = True
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    State = cbChecked
    TabOrder = 6
  end
  object ReplaceAllBtn: TButton
    Left = 316
    Top = 164
    Width = 121
    Height = 25
    Caption = 'Replace All'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Arial'
    Font.Style = [fsItalic]
    ParentFont = False
    TabOrder = 7
    OnClick = ReplaceAllBtnClick
  end
  object ReplAllScopeChk: TCheckBox
    Left = 324
    Top = 204
    Width = 113
    Height = 17
    Caption = '... in selection'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 8
  end
  object FindStartBtn: TButton
    Left = 12
    Top = 204
    Width = 137
    Height = 25
    Caption = 'Find From Text Start'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsItalic]
    ParentFont = False
    TabOrder = 9
    OnClick = FindStartBtnClick
  end
end
