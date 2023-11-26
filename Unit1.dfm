object Form1: TForm1
  Width = 1077
  Height = 828
  Color = clBlack
  CSSLibrary = cssBootstrap
  ElementFont = efCSS
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -15
  Font.Name = 'Tahoma'
  Font.Style = []
  ParentFont = False
  Shadow = False
  OnCreate = WebFormCreate
  object divPhotos: TWebHTMLDiv
    Left = 0
    Top = 0
    Width = 1280
    Height = 800
    ElementID = 'divPhotos'
    ChildOrder = 10
    ElementFont = efCSS
    Role = ''
  end
  object tmrStart: TWebTimer
    Enabled = False
    Interval = 0
    OnTimer = tmrStartTimer
    Left = 296
    Top = 248
  end
  object tmrRefresh: TWebTimer
    Enabled = False
    Interval = 10000
    OnTimer = tmrRefreshTimer
    Left = 304
    Top = 336
  end
end
