object EditForm: TEditForm
  Left = 231
  Top = 112
  Width = 790
  Height = 559
  HorzScrollBar.Visible = False
  VertScrollBar.Visible = False
  BorderIcons = [biSystemMenu, biMaximize]
  Caption = 'Elizabeth Script Editor'
  Color = clBtnFace
  Constraints.MinHeight = 240
  Constraints.MinWidth = 240
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
  Menu = EditorMenu
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 14
  object EditorLbl: TLabel
    Left = 12
    Top = 0
    Width = 750
    Height = 22
    Alignment = taCenter
    AutoSize = False
    Caption = '(no file)'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    Layout = tlCenter
  end
  object RichEdit1: TRichEdit
    Left = 20
    Top = 32
    Width = 721
    Height = 457
    Lines.Strings = (
      'RichEdit1')
    TabOrder = 1
  end
  object EditorMemo: TMemo
    Left = 12
    Top = 24
    Width = 750
    Height = 467
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Courier New'
    Font.Style = []
    HideSelection = False
    ParentFont = False
    ScrollBars = ssBoth
    TabOrder = 0
    WordWrap = False
    OnChange = EditorMemoChange
    OnKeyUp = EditorMemoKeyUp
    OnMouseUp = EditorMemoMouseUp
  end
  object EditorMenu: TMainMenu
    Left = 20
    Top = 16
    object EMenuFile: TMenuItem
      Caption = '&File'
      object EMenuFileNew: TMenuItem
        Caption = '&New'
        OnClick = EMenuFileNewClick
      end
      object EMenuFileOpen: TMenuItem
        Caption = '&Open existing script file'
        OnClick = EMenuFileOpenClick
      end
      object EMenuFileLoad: TMenuItem
        Caption = '&Load script from Elizabeth into Editor'
        OnClick = EMenuFileLoadClick
      end
      object EMenuFilePrint: TMenuItem
        Caption = '&Print'
        ShortCut = 16464
        OnClick = EMenuFilePrintClick
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object EMenuFileSave: TMenuItem
        Caption = '&Save'
        OnClick = EMenuFileSaveClick
      end
      object EMenuFileSaveAs: TMenuItem
        Caption = 'Save &As ...'
        OnClick = EMenuFileSaveAsClick
      end
      object EMenuFileRestart: TMenuItem
        Caption = '&Restart Elizabeth after saving'
        ShortCut = 16466
        OnClick = EMenuFileRestartClick
      end
      object EMenuFileTransfer: TMenuItem
        Caption = '&Transfer script into Elizabeth after saving'
        ShortCut = 16468
        OnClick = EMenuFileTransferClick
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object EMenuFileSwitch: TMenuItem
        Caption = 'Switch back to &Elizabeth'
        ShortCut = 16453
        OnClick = EMenuFileSwitchClick
      end
      object EMenuFileClose: TMenuItem
        Caption = '&Close Script Editor'
        OnClick = EMenuFileCloseClick
      end
    end
    object EMenuEdit: TMenuItem
      Caption = '&Edit'
      object EMenuEditCut: TMenuItem
        Caption = 'Cut'
        ShortCut = 16472
        OnClick = EMenuEditCutClick
      end
      object EMenuEditCopy: TMenuItem
        Caption = 'Copy'
        ShortCut = 16451
        OnClick = EMenuEditCopyClick
      end
      object EMenuEditPaste: TMenuItem
        Caption = 'Paste'
        ShortCut = 16470
        OnClick = EMenuEditPasteClick
      end
      object N3: TMenuItem
        Caption = '-'
      end
      object EMenuEditFind: TMenuItem
        Caption = 'Find/Replace'
        ShortCut = 16454
        OnClick = EMenuEditFindClick
      end
      object EMenuEditUndo: TMenuItem
        Caption = 'Undo'
        ShortCut = 16474
        Visible = False
        OnClick = EMenuEditUndoClick
      end
    end
    object EMenuView: TMenuItem
      Caption = '&View'
      object EMenuViewFont: TMenuItem
        Caption = '&Font'
        OnClick = EMenuViewFontClick
      end
      object EMenuViewWordwrap: TMenuItem
        Caption = '&Wordwrap'
        OnClick = EMenuViewWordwrapClick
      end
    end
  end
  object EditOpenDlg: TOpenDialog
    DefaultExt = 'txt'
    FileName = 'Elizabeth.txt'
    Filter = 'Text files (*.txt)|*.txt|All files (*.*)|*.*'
    Options = [ofHideReadOnly, ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Title = 'Open Elizabeth script file'
    Left = 52
    Top = 16
  end
  object EditSaveDlg: TSaveDialog
    DefaultExt = 'doc'
    FileName = 'Elizabeth.txt'
    Filter = 'Text files (*.txt)|*.txt|All files (*.*)|*.*'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Title = 'Save edited script file'
    Left = 84
    Top = 16
  end
  object EditorFontDlg: TFontDialog
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Left = 116
    Top = 16
  end
  object EditPrintSetupDlg: TPrinterSetupDialog
    Left = 148
    Top = 16
  end
end
