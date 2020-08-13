object ActionForm: TActionForm
  Left = 635
  Top = 777
  HorzScrollBar.Visible = False
  VertScrollBar.Visible = False
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Condition / Action Specification'
  ClientHeight = 189
  ClientWidth = 681
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
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
  TextHeight = 14
  object ActionLbl: TLabel
    Left = 12
    Top = 144
    Width = 657
    Height = 33
    Color = clBtnHighlight
    Constraints.MaxWidth = 657
    Constraints.MinHeight = 33
    Constraints.MinWidth = 657
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Courier New'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
    Layout = tlCenter
    WordWrap = True
  end
  object Label1: TLabel
    Left = 12
    Top = 106
    Width = 657
    Height = 25
    AutoSize = False
    Caption = 'The action associated with this operation is as follows:'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Arial'
    Font.Style = [fsItalic]
    ParentFont = False
    Layout = tlCenter
  end
  object CondLbl: TLabel
    Left = 12
    Top = 48
    Width = 657
    Height = 33
    Color = clBtnHighlight
    Constraints.MaxWidth = 657
    Constraints.MinHeight = 33
    Constraints.MinWidth = 657
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Courier New'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
    Layout = tlCenter
    WordWrap = True
  end
  object Label3: TLabel
    Left = 12
    Top = 10
    Width = 657
    Height = 25
    AutoSize = False
    Caption = 'The condition associated with this operation is as follows:'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Arial'
    Font.Style = [fsItalic]
    ParentFont = False
    Layout = tlCenter
  end
end
